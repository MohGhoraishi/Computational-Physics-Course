using LinearAlgebra
using Plots
using Colors

#initial values

x_0 = 0
x = -10
x_prime = -x
y_0 = 0
y_prime = y = x
steps = 20

#defining function to split line clockwise

function line_split_clockwise(x_1, x_2, y_1, y_2)
    x_new = x_1 + 1 / 2 * (x_2 - x_1) + 1 / 2 * (y_2 - y_1)
    y_new = y_1 - 1 / 2 * (x_2 - x_1) + 1 / 2 * (y_2 - y_1)
    return x_new, y_new
end

#defining function to split line anticlockwise

function line_split_anticlockwise(x_1, x_2, y_1, y_2)
    x_new = x_1 + 1 / 2 * (x_2 - x_1) - 1 / 2 * (y_2 - y_1)
    y_new = y_1 + 1 / 2 * (x_2 - x_1) + 1 / 2 * (y_2 - y_1)
    return x_new, y_new
end

#defining recursive function that oscillates between line_split_clockwise and line_split_anticlockwise


function fractalize(x_1, x_2, y_1, y_2, n, i)
    if i % 2 == 0
        x_new , y_new = line_split_clockwise(x_1, x_2, y_1, y_2)
    else
        x_new , y_new = line_split_anticlockwise(x_1, x_2, y_1, y_2)
    end
    x_new_1 = x_new_2 = y_new_1 = y_new_2 = []
    if n > 0
        x_new_1, y_new_1 = fractalize(x_1, x_new, y_1, y_new, n - 1, 1)
        x_new_2, y_new_2 = fractalize(x_new, x_2, y_new, y_2, n - 1, 0)
        dotx = []
        doty = []
    else
        dotx = [x_new , x_2]
        doty = [y_new, y_2]
    end

    append!(dotx, x_new_1, x_new_2)
    append!(doty, y_new_1, y_new_2)

    return dotx, doty
end

#final touches, calling the fractalize function twice for the blue and pink lines then plotting
X = [float(x_0)]
Y = [float(y_0)]
dotx, doty = fractalize(x_0, x, y_0, y, steps, 0)
append!(X, dotx)
append!(Y, doty)
X_prime= [float(x_0)]
Y_prime= [float(y_0)]
dotx_prime, doty_prime = fractalize(x_0, x_prime, y_0, y_prime, steps, 0)
append!(X_prime, dotx_prime)
append!(Y_prime, doty_prime)
steps = steps + 1
s = raw"steps=" * "$steps"
plot(X, Y, aspect_ratio = 1, title = s, linecolor = RGB(255/255,105/255,180/255), background = RGB(0.1, 0.1, 0.1))
plot!(X_prime, Y_prime, linecolor = RGB(40/255,40/255,255/255))