using LinearAlgebra
using Plots
using Colors
using Statistics
gr()

n = 1000 #number of steps
N = 10000 #number of runs to average for each P and initial state
toplimit = 20 #top limit of our grid
botlimit = -20 #bot limit of our grid

#function that simulates a random walk with boundary comditions
function randwalkdeath(P, x0) #probability of going right and number of steps and the initial state
    X = [x0]
    T = 0
    i = 2
    while 1 == 1
        num = rand(1:100)
        if num <= P
            push!(X, X[i - 1] + 1)
        else   
            push!(X, X[i - 1] - 1)
        end
        T = T + 1
        if (X[i] < botlimit) || (X[i] > toplimit)
            break
        end
        i = i + 1
    end
    return T
end

#loop that averages the results for 10 different P values and all possible initial states
labels = Array{Any}(undef, 1, 11)#labels of each data set
finalT = []#array containing arrays of each set
finalStates = []
for j in 0:10
    prob = j * 10 #probability percentage
    resultsPerState = []
    initialState = []
    for i in 0:(toplimit - botlimit)
        resultsT = Float64[]
        initstate = botlimit + i #initial state
        for k in 1:10000
            push!(resultsT, randwalkdeath(prob, initstate))
        end
        push!(resultsPerState, mean(resultsT))
        push!(initialState, initstate)
    end
    string = raw"P = " * "$prob"
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



