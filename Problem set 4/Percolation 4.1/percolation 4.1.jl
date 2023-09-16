using LinearAlgebra
using Plots
using Colors
gr()

L = 100 #number of rows
M = zeros(L, L)
P = 50 #Probability

#Building the Matrix using a random generator
for i in 1:L
    for j in 1:L
        num = rand(1:100)
        if num < P
            M[i, j] = 10
        end
    end
end
s = raw"L = " * "$L"
#Plotting using a heatmap
heatmap(M,
    color = :thermal,
    width = L,
    height = L,
    dpi = 500,
    aspect_ratio = 1,
    background = :black,
    title = s,
    legend = false,)

