using LinearAlgebra
using Plots
using Colors

#initial values

x_0 = 0
x_prime = 10
y_0 = 0
y_prime = 0
steps = 7

#function to find the location of the 3 dots

function line_split(x_1, x_2, y_1, y_2, steps)
    n = steps
    x1 = x_1 + (x_2 - x_1) / 3
    y1 = y_1 + (y_2 - y_1) / 3
    x3 = x_1 + 2 * (x_2 - x_1) / 3
    y3 = y_1 + 2 * (y_2 - y_1) / 3
    x2 = x1 + 1 / 2 * (x3 - x1) - 3 ^ (1 / 2) / 2 * (y3 - y1)
    y2 = y1 + 3 ^ (1 / 2) / 2 * (x3 - x1) + 1 / 2 * (y3 - y1)

    #recursive if statement
    dotx_1 = dotx_2 = dotx_3 = dotx_4 = []
    doty_1 = doty_2 = doty_3 = doty_4 = []
    if n > 0
        dotx_1, doty_1 = line_split(x_1, x1, y_1, y1, n - 1)
        dotx_2, doty_2 = line_split(x1, x2, y1, y2, n - 1)
        dotx_3, doty_3 = line_split(x2, x3, y2, y3, n - 1)
        dotx_4, doty_4 = line_split(x3, x_2, y3, y_2, n - 1)
        dotx = []
        doty = []
    else 
        dotx = [x1, x2, x3, x_2]
        doty = [y1, y2, y3, y_2]
    end
    append!(dotx, dotx_1, dotx_2, dotx_3, dotx_4)
    append!(doty, doty_1, doty_2, doty_3, doty_4)

    return dotx, doty
    
end

#final touches and plotting

X = [float(x_0)]
Y = [float(y_0)]
dotx, doty = line_split(x_0, x_prime, y_0, y_prime, steps - 1)
append!(X, dotx)
append!(Y, doty)
plot(X, Y, aspect_ratio = 1, title = "steps = 13", linecolor = RGB(255/255,105/255,180/255))