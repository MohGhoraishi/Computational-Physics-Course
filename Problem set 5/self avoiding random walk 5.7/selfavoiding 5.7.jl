using LinearAlgebra
using Plots
using Colors
gr()

N = 15

#function that counts the number of paths with length N
function count(matrix, remainingSteps, x, y)
    if remainingSteps == 0
        global num += 1
        return
    end
    if matrix[y, x + 1] != 1
        M2 = deepcopy(matrix)
        M2[y, x + 1] = 1
        count(M2, remainingSteps - 1, x + 1, y)
    end
    if matrix[y, x - 1] != 1
        M2 = deepcopy(matrix)
        M2[y, x - 1] = 1
        count(M2, remainingSteps - 1, x - 1, y)
    end
    if matrix[y + 1, x] != 1
        M2 = deepcopy(matrix)
        M2[y + 1, x] = 1
        count(M2, remainingSteps - 1, x, y + 1)
    end
    if matrix[y - 1, x] != 1
        M2 = deepcopy(matrix)
        M2[y - 1, x] = 1
        count(M2, remainingSteps - 1, x, y - 1)
    end
end
#main loop to generate necessary data
pathsSelfAvoiding = []
pathRelative = []
Ns = []
for i in 1:N
    global M = zeros(2 * i + 3, 2 * i + 3) #matrix big enough to disregard the edges
    global M[i + 2, i + 2] = 1 #starting point
    global num = 0 #number of paths
    count(M, i, i + 2, i + 2)
    paths = num
    push!(pathsSelfAvoiding, paths)
    push!(pathRelative, paths / 4^i)
    push!(Ns, i)
end

#plotting
# plot(Ns, pathsSelfAvoiding,
#     background = :black,
#     markerstrokealpha = 0,
#     title = "number of available paths for self avoiding \n random walk",
#     xlabel = "N",
#     ylabel = "number of paths",
#     dpi = 500, 
#     legend = false
# )

plot(Ns, pathRelative,
    background = :black,
    markerstrokealpha = 0,
    title = "number of available paths for self avoiding \n random walk Ralative to the number of \n free paths",
    xlabel = "N",
    ylabel = "Relative number of paths",
    dpi = 500, 
    legend = false
)
