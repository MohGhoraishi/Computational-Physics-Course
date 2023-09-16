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

#function that calculates the correlation length around the mean
function correlationlength(M, num)
    X = []
    Y = []
    for i in 1:width
        for j in 1:width
            if M[i, j] == num
                push!(X, j)
                push!(Y, i)
            end
        end
    end
    meany = mean(Y)
    meanx = mean(X)
    for i in 1:length(X)
        X[i] = X[i] - meanx
        Y[i] = Y[i] - meany
    end
    sigmax = stdm(X, mean(X))
    sigmay = stdm(Y, mean(Y))
    z = sigmax^2 + sigmay^2
    return z
end

#function that tests if a label exists 
function exists(M, num)
    for i in 1:width
        for j in 1:width
            if M[i, j] == num
                return 1
            end
        end
    end
    return 0
end
nom, matrix = perc(width, 50)
Ps = []
Z = []
width = 20
#main averaging loop
for i in 0:20
    results = Float64[]
    for k in 1:100
        zs = Float64[]
        test, mat = perc(width, i * 5)
        if test == 1
            start = 2
        else
            start = 1
        end
        for j in start:width^2
            if exists(mat, j) == 1
                push!(zs, correlationlength(mat, j))
            end
        end
        filter!(!isnan, zs) #filtering out bad data
        push!(results, mean(zs))
    end
    push!(Ps, i * 0.05)
    push!(Z, mean(results))
end

#Plotting
s = raw"L = " * "$width"
scatter(Ps, Z,
    markercolor = :blue,
    markersize = 3,
    markeralpha = 1,
    background = :black,
    markerstrokealpha = 0,
    title = s,
    xlabel = "P",
    ylabel = "Z",
    dpi = 500, 
)