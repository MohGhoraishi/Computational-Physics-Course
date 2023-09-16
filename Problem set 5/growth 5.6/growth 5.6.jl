using LinearAlgebra
using Plots
using Colors
using Statistics
gr()

#initial values
width = 400
height = 500
maxnumber = 100 #the maximum number assignedd to the matrix
steps = 15000 #number of steps

#Building the initial matrix
M = zeros(height, width)
#the seed is represented by 100s and blocked squares are represented by -1
M[1,:] .= 100
M[:, 1] .= -1
M[:, width] .= -1
M[height, :] .= -1

#function that returns the max height of the cluster
function maxheight(matrix)
    maxheight = 1
    for i in 2:height
        tester = 0
        for j in 1:width
            if matrix[i, j] > 0
                tester = 1
                break
            end
        end
        if tester == 0
            maxheight = i
            break
        end
    end
    return maxheight
end

#function that creates a random walk 20 units above the max height in a random x and runs until the walker reaches the cluster
function randomwalk(matrix)
    X = Int(rand(2:width - 1))
    Y = Int(maxheight(matrix) + 20)
    while 1 == 1
        num = rand(1:4)
        if num == 1
            if checkneighbours(matrix, X, Y) == 1
                global maxnumber += 1
                matrix[Y, X] = maxnumber
                break
            elseif matrix[Y, X + 1] == 0 #the walker stops on the edges if it decides to go somewhere it shouldn't
                X += 1
            end
        elseif num == 2
            if checkneighbours(matrix, X, Y) == 1
                global maxnumber += 1
                matrix[Y, X] = maxnumber
                break
            elseif matrix[Y, X - 1] == 0
                X -= 1
            end
        elseif num ==3
            if checkneighbours(matrix, X, Y) == 1
                global maxnumber += 1
                matrix[Y, X] = maxnumber
                break
            elseif matrix[Y + 1, X] == 0
                Y += 1
            end
        elseif num == 4
            if checkneighbours(matrix, X, Y) == 1
                global maxnumber += 1
                matrix[Y, X] = maxnumber
                break
            elseif matrix[Y - 1, X] == 0
                Y -= 1
            end
        end
    end
    return matrix
end

#function that checks neibouring cells for an attachable cluster
function checkneighbours(matrix, x, y)
    if matrix[y + 1, x] > 0
        return 1
    elseif matrix[y - 1, x] > 0
        return 1
    elseif matrix[y, x + 1] > 0
        return 1
    elseif matrix[y, x - 1] > 0
        return 1
    else
        return 0
    end
end

#main loop
for i in 1:steps
    global M = randomwalk(M)
end

#Plotting using a heatmap
heatmap(M,
color = :thermal,
dpi = 500,
aspect_ratio = 1,
legend = false,
title = "steps = $steps",
background = :black,)