using LinearAlgebra
using Plots
using Colors
using Statistics
gr()

L = 20

#function that calculates the time neccessary to trap the walker
function timepassed(P, X0)
    Pos = zeros(L + 2)
    Pos[X0] = 1.0
    Time = 0
    while Pos[1] + Pos[end] < 0.99
        Pos2 = copy(Pos)
        for i in 2: L + 1
            Pos2[i+1] += Pos[i]*(1-P)
            Pos2[i-1] += Pos[i]*P
            Pos2[i] -= Pos[i]
        end
        Pos = Pos2
        Time += 1
    end
    return Time
end

#loop that averages the results for 10 different P values and all possible initial states
labels = Array{Any}(undef, 1, 11)#labels of each data set
finalT = []#array containing arrays of each set
finalStates = []
for j in 0:10
    prob = j * 0.1 #probability percentage
    probper100 = j * 10
    resultsPerState = []
    initialState = []
    for i in 1:L + 2
        initstate = i #initial state
        push!(resultsPerState, timepassed(prob, initstate))
        push!(initialState, initstate)
    end
    string = raw"P = " * "$probper100"
    push!(finalT, resultsPerState)
    push!(finalStates, initialState)
    labels[1, j + 1] = string
end

#plotting
plot(finalStates, finalT,
    background = :black,
    title = "Average time of death per initial states \n for multiple Ps",
    xlabel = "initial state",
    ylabel = "T",
    dpi = 500, 
    label = labels
)