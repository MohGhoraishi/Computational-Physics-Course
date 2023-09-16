using LinearAlgebra
using Plots
using Colors
gr()

L = 20 #number of rows
M = zeros(Int, (L, L))
P = 40 #Probability

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
labels = []
for i in 1:L^2 + 1
    push!(labels, i)
end
#labeling the leftmost edge as 1
for i in 1:L
    label[i, 1] = 1
end

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

#the main loop
for y in 2:L
    for x in 2:L
        if M[x, y] == 1
            left = label[x, y-1] #label of cell to the left
            above = label[x-1, y] #label of cell above
            if (left == 0) && (above == 0) #the cells above and to the left don't have a label so we create a new label
                global largest_label = largest_label + 1
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
        global s = raw"L = " * "$L" * ", P = " * "$P" * " Percolation happened"
        break
    end
    global s = raw"L = " * "$L" * ", P = " * "$P" * " Percolation didn't happen"
end

for i in 1:L
    for j in 1:L
        if label[i, j] == labels[1]
            label[i, j] = largest_label * 2
        end   
    end
end



#Plotting using a heatmap
 heatmap(label,
    color = :thermal,
    dpi = 500,
    aspect_ratio = 1,
    title = s,
    background = :black,)