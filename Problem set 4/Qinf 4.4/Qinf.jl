using LinearAlgebra
using Plots
using Colors
using Statistics
gr()

#defining the merge function to merge clusters
function merge(a, b)
    if labels[a] < labels[b]
        for i in 1:b
            if labels[i] == labels[b]
                global labels[i] = labels[a]
            end
        end
    elseif labels[b] < labels[a]
        for i in 1:a
            if labels[i] == labels[a]
                global labels[i] = labels[b]
            end
        end
    end
end

function perc(L, P)
    M = zeros(Int, (L, L))
    num = 1

    #Building the Matrix using a random generator
    for i in 1:L
        for j in 1:L
            num = rand(1:100)
            if num < P
                M[i, j] = 1
            end
        end
    end

    #defining the labels
    largest_label = 1;
    label = zeros(Int, (L, L))
    global labels = []
    for i in 1:L^2 + 1
        push!(labels, i)
    end
    #labeling the leftmost edge as 1
    for i in 1:L
        label[i, 1] = 1
    end



    #the main loop
    for y in 2:L
        for x in 2:L
            if M[x, y] == 1
                left = label[x, y-1] #label of cell to the left
                above = label[x-1, y] #label of cell above
                if (left == 0) && (above == 0) #the cells above and to the left don't have a label so we create a new label
                    largest_label = largest_label + 1
                    label[x, y] = largest_label
                elseif (left != 0) && (above == 0) #left cell has a label so we merge the cluster with the left cell
                    label[x, y] = left
                elseif (left == 0) && (above != 0) #above cell has a label so we merge the cluster with the above cell
                    label[x, y] = above
                elseif  (left != 0) && (above != 0) #both cells have a label so we merge all the cells into a cluster
                    merge(left, above)
                    label[x, y] = minimum([left, above])
                end
            end
        end
    end

    for i in 1:L
        for j in 1:L
            if label[i, j] != 0
                label[i, j] = labels[label[i, j]]
            end

        end
    end
     for i in 1:L
         if label[i, L] == 1
             num = 1
             break
         end
     end

    return num, label
end

#function that counts the number of labels with amount one
function count(M, size)
    counter = 0
    for i in 1:size
        for j in 1:size
            if M[i,j] == 1
                counter = counter + 1
            end
        end
    end
    return counter
end

Qinf = []
Qdev = []
Ps = []
width = 200
for i in 0:40
    results = []
    for j in 1:100
        test, mat = perc(width, 50 + i * 1.25)
        if test == 1
            push!(results, count(mat, width))
        else
            push!(results, 0)
        end
    end
    push!(Ps, 0.5 + i * 0.0125)
    push!(Qinf, mean(results))
    push!(Qdev, stdm(results, mean(results)))
end

s = raw"L = " * "$width"
scatter(Ps, Qinf,
    markercolor = :blue,
    markersize = 3,
    markeralpha = 1,
    background = :black,
    markerstrokealpha = 0,
    title = s,
    xlabel = "P",
    ylabel = "Q_inf",
    dpi = 500, 
    yerror = Qdev
)


