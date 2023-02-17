using LinearAlgebra
using Plots, Plots.PlotMeasures
using Colors
gr()

#initial values
delta = 0.1
X = []
Y = []
steps = 30

#function to generate the number of a specific index

function khayyam_number(n, m)
    num = factorial(big(n)) / factorial(big(m)) / factorial(big(n - m))
    return num
end

s = raw"steps=" * "$steps"

#function that generates the number of every index and keeps it if it's odd
for i in 0:steps
    if i % 2 == 0
        x0 = - i
    else 
        x0 = - i + 1 / 2
    end
    for j in 0:i
        xnew = (x0 + 2 * j) * delta
        ynew = - i * delta
        num = khayyam_number(i, j)
        if num % 2 == 1
            push!(X, xnew)
            push!(Y, ynew)
        end

    end
end

#final touches and plotting

steps = steps + 1
s = raw"steps=" * "$steps"

scatter(X, Y,
    marker = (:square),
    markeralpha = 1,
    markercolor = :pink,
    background = RGB(0.1, 0.1, 0.1),
    markerstrokewidth = 0,
    markerstrokealpha = 0,
    title = s,
    aspect_ratio = 1
) 
