using LinearAlgebra
using Plots
using Colors
using Statistics
using Polynomials
gr()

n = 100000 #number of steps
N = 1000 #number of runs to average

#function that simulates a 2d random walk and returns the distance squared from the origin (each step is 1 unit long)
function randwalk2D(n)
    X = 0
    Y = 0
    for i in 1:n
        num = rand(1:4)
        if num == 1
            X = X + 1
        elseif num == 2
            X = X - 1
        elseif num ==3
            Y = Y + 1
        elseif num == 4
            Y = Y - 1
        end
    end
    return (X^2 + Y^2)
end

time = LinRange(1, n, n)
R = Float64[]
#averaging loop
for i in 1:n
    results = Float64[]
    for j in 1:N
        push!(results, randwalk2D(i))
    end
    push!(R, mean(results))
end

Rtheory = []
for i in 1:n
    push!(Rtheory, 2 * 2 * 1 / 4 * time[i])
end

#plotting
s = raw"rbar^2 with number of steps = " * "$n"
plot(time, R,
    background = :black,
    markerstrokealpha = 0,
    title = s,
    xlabel = "t",
    ylabel = "rbar^2",
    dpi = 500, 
    label = "simulation"
)

plot!(time, Rtheory, label = "theoretical")
