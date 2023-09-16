using LinearAlgebra
using Plots
using Colors
using Statistics
using Polynomials
gr()

L = 100 #number of rows
P = 59 #Probability

function creatematrix()
    M0 = zeros(L+2, L+2)
    for i in 1:L+2 #creating walls on the edge
        M0[i, 1] = 2
        M0[i, L+2] = 2
        M0[1, i] = 2
        M0[L+2, i] = 2
    end
    M0[Int(L/2+1), Int(L/2+1)] = 1
    return M0
end

M0 = creatematrix()
#recursive function that grows the custer with the rules of the game until it couldn't anymore
function grow(i, j)
    if M0[i-1, j] == 0
        num = rand(1:100)
        if num <= P
            global M0[i-1, j] = 1
            grow(i-1, j)
        else
            global M0[i-1, j] = 2
        end
    end
    if M0[i, j-1] == 0
        num = rand(1:100)
        if num <= P
            global M0[i, j-1] = 1
            grow(i, j-1)
        else
            global M0[i, j-1] = 2
        end
    end
    if M0[i, j+1] == 0
        num = rand(1:100)
        if num <= P
            global M0[i, j+1] = 1
            grow(i, j+1)
        else
            global M0[i, j+1] = 2
        end
    end
    if M0[i+1, j] == 0
        num = rand(1:100)
        if num <= P
            global M0[i+1, j] = 1
            grow(i+1, j)
        else
            global M0[i+1, j] = 2
        end
    end
end

#function that calculates the correlation length around the mean
function correlationlength(M)
    X = []
    Y = []
    for i in 1:L+2
        for j in 1:L+2
            if M[i, j] == 1
                push!(X, j - (Int(L/2 + 1)))
                push!(Y, i - (Int(L/2 + 1)))
            end
        end
    end
    sigmax = stdm(X, mean(X))
    sigmay = stdm(Y, mean(Y))
    z = sigmax^2 + sigmay^2
    return z
end

#function to find the size of the cluster
function findsize(M)
    count = 0
    for i in 1:L+2
        for j in 1:L+2
            if M[i, j] == 1
                count = count + 1
            end
        end
    end
    return count
end

logs = Float64[]
logz = Float64[]
#main data loop
for i in 1:1000
    global M0 = creatematrix()
    grow(Int(L/2 + 1), Int(L/2 + 1))
    z = correlationlength(M0)
    s = findsize(M0)
    push!(logs, log(s))
    push!(logz, log(z))
end
#loop to remove bad data
for i in 1:length(logz)
    if isnan(logz[i])
        logz[i] = 0
        logs[i] = 0
    end
end
s = raw"P = " * "$P"
fh = fit(logz, logs, 1)
scatter(logz, logs,
    markercolor = :blue,
    markersize = 3,
    markeralpha = 1,
    background = :black,
    markerstrokealpha = 0,
    title = s,
    xlabel = "Log(s)",
    ylabel = "Log(z)",
    dpi = 500
)
plot!(fh, extrema(logz)..., label="Linear Fit ($fh)")


#Plotting using a heatmap
#heatmap(M0,
#color = :thermal,
#dpi = 500,
#aspect_ratio = 1,
#title = s,
#background = :black,)