using LinearAlgebra
using Plots
using Colors
gr()

#initial values
steps = 1000
P = 500
X = []
Y = []

#Three transformation functions that create the sierpinski triangle
f1(coords) = coords / 2
f2(coords) = coords / 2 + [1 ; 0]
f3(coords) = coords / 2 + [0.5 ; 1]

#the main algorithm that randomly selects points and transforms them
for i in 1:steps
    coords = [rand() ; rand()]
    for j in 1:P
        random = rand([1, 2, 3])
        if random == 1 
            coords = f1(coords)
        elseif random == 2 
            coords = f2(coords)
        else
            coords = f3(coords)
        end
        push!(X, coords[1])
        push!(Y, coords[2])
    end
end

#final touches and plotting

s = raw"steps=" * "$steps" * ", P=" * "$P"

scatter(X, Y,
    marker = (:square),
    markersize = 0.01,
    markeralpha = 1,
    markercolor = :orange,
    background = RGB(0.1, 0.1, 0.1),
    markerstrokewidth = 0,
    markerstrokealpha = 0,
    title = s,
    aspect_ratio = 1,
    legend = false,
    dpi = 500
) 
