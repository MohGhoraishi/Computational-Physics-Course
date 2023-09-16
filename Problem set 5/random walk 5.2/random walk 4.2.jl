using LinearAlgebra
using Plots
using Colors
using Statistics
gr()

n = 1000 #number of steps
N = 10000 #number of runs to average for each P

#random walk function
function randwalk(P , n) #probability of going right and number of steps
    X = [0]
    T = [0]
    for i in 2:n + 1
        num = rand(1:100)
        if num <= P
            push!(X, X[i - 1] + 1)
            push!(T, T[i - 1] + 1)
        else   
            push!(X, X[i - 1] - 1)
            push!(T, T[i - 1] + 1)
        end
    end
    return T, X
end

# Commented code that plots two runs of the random walk on one graph

# T, X = randwalk(P, n)
# T2, X2 = randwalk(P, n)
# s = raw"P = " * "$P" * " n = " * "$n"
# plot(T, X,
#     background = :black,
#     markerstrokealpha = 0,
#     title = s,
#     xlabel = "t",
#     ylabel = "x",
#     label = "run 1",
#     dpi = 500, 
# )
# plot!(T2, X2, label = "run 2")

# Loop that averages over a number of runs for 
Xbar = []  #xbar
Xdev2 = [] #sigma^2
Ps = [] #probabilities
time = LinRange(1, n, n)
for i in 1:40
    push!(Ps, i * 0.025)
    resultsx = []
    for j in 1:N
        T, X = randwalk(i * 2.5, n)
        push!(resultsx, X[n])
    end
    push!(Xbar, mean(resultsx))
    push!(Xdev2, stdm(resultsx, mean(resultsx)) ^ 2)
end

#commented code to plot xbar and its theoretical value
#theoretical xbar and xdev2 values
Xbartheory = []
Xdev2theory = []
for i in 1:40
    push!(Xbartheory, (2 * Ps[i] - 1) * n)
    push!(Xdev2theory, 4 * Ps[i] * (1 - Ps[i]) * n)
end

#commented code to plot xbar and its theoretical value
# s = raw"Xbar with number of steps = " * "$n"
# scatter(Ps, Xbar,
#     background = :black,
#     markerstrokealpha = 0,
#     title = s,
#     xlabel = "P",
#     ylabel = "Xbar",
#     dpi = 500, 
#     label = "simulation"
# )

# plot!(Ps, Xbartheory, label = "theoretical")

#plotting the deviation and its theoretical value
s = raw"sigma^2 with number of steps = " * "$n"
scatter(Ps, Xdev2,
    background = :black,
    markerstrokealpha = 0,
    title = s,
    xlabel = "P",
    ylabel = "Xbar",
    dpi = 500, 
    label = "simulation"
)

plot!(Ps, Xdev2theory, label = "theoretical")
