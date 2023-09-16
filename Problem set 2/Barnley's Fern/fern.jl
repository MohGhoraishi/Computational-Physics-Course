using LinearAlgebra
using Plots
using Colors
gr()

#initial values and parameters
steps = 1000000
point = [float(0) ; float(10)]
X = [float(0)]
Y = [float(10)]
#probabilities in percentage
p1 = 1
p2 = 85
p3 = 7
p4 = 7

#functions used to transform the points
#the parameters for the rotation and transportation matrices should be changed here
f1(coords) = [0 ; coords[2] * 0.16]
f2(coords) = [0.85 * coords[1] + 0.04 * coords[2] ; -0.04 * coords[1] + 0.85 * coords[2] + 1.6]
f3(coords) = [0.2 * coords[1] - 0.26 * coords[2] ; 0.23 * coords[1] + 0.22 * coords[2] + 1.6]
f4(coords) = [-0.15 * coords[1] + 0.28 * coords[2] ; 0.26 * coords[1] + 0.24 * coords[2] + 0.44]

#loop that transforms the dots randomly using the above transformations
for i in 1:steps
    tester = rand(1:100)
    if tester <= p1
        global point = f1(point)
    elseif tester > p1 && tester <= p1 + p2
        global point = f2(point)
    elseif tester > p1 + p2 && tester <= p1 + p2 + p3
        global point = f3(point)
    else
        global point = f4(point)
    end
    push!(X, point[1])
    push!(Y, point[2])
end

#final touches and plotting
s = raw"steps=" * "$steps"
scatter(X, Y,
    markersize = 0.001,
    markeralpha = 1,
    markercolor = :orangered,
    background = RGB(0.1, 0.1, 0.1),
    markerstrokewidth = 0,
    markerstrokealpha = 0,
    title = s,
    aspect_ratio = 1,
    legend = false,
    dpi = 500
) 