using LinearAlgebra
using Plots, Plots.PlotMeasures
using Colors
gr()
#initial values
y = [0]
x = [0]
steps = 0
marker_size = 300
max_size = 10
#in order for the marker to have 10 unit long sides, markersize has to be 300

#function that creates 3 new dots around a dot which each of these dots are the centers of the new triangle
function new_dots(x_1, y_1, n, i)
    x1 = x_1
    y1 = y_1 + 10 / (2 ^ i) * sqrt(3) / 3
    x2 = x_1 - 10 / (2 ^ i) / 2
    y2 = y_1 - 10 / (2 ^ i) * sqrt(3) / 6
    x3 = x_1 + 10 / (2 ^ i) / 2
    y3 = y_1 - 10 / (2 ^ i) * sqrt(3) / 6

    dotx_1 = dotx_2 = dotx_3 = []
    doty_1 = doty_2 = doty_3 = []

    #recursive if statement
    
    if n > 0
        dotx_1, doty_1 = new_dots(x1, y1, n - 1, i + 1)
        dotx_2, doty_2 = new_dots(x2, y2, n - 1, i + 1)
        dotx_3, doty_3 = new_dots(x3, y3, n - 1, i + 1)
        dotx = []
        doty = []
    else  
        dotx = [x1, x2, x3]
        doty = [y1, y2, y3]
    end
    append!(dotx, dotx_1, dotx_2, dotx_3)
    append!(doty, doty_1, doty_2, doty_3)
    return dotx, doty
end

#we define a triangle with equal sides as a shape with the below coordinates then use this shape as a marker
verts = [(-1, -sqrt(3) / 3), (+ 1, -sqrt(3) / 3), (0, 2 * sqrt(3) / 3), (-1, -sqrt(3) / 3)]

#final touches and plotting

steps = steps + 1
s = raw"steps=" * "$steps"

X, Y = new_dots(0, 0, steps, 0)

scatter(X, Y,
    marker = (Shape(verts), marker_size / (2 ^ (steps + 1))),
    markeralpha = 1,
    markercolor = :blue,
    markerstrokewidth = 0,
    markerstrokealpha = 0,
    xlims=(-max_size, max_size), 
    ylims=(-7, 13),
    title = s,
    aspect_ratio = 1
)