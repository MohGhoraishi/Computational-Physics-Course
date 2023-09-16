using LinearAlgebra
using StatsPlots
using Colors
using Polynomials
gr()

#initial values
L = 200 #number of bins
count = 100000 #number of total dots placed
t = 0 #time that starts at zero and a dot is placed with every unit of time
H = zeros(L) #array that stores the height
T = Float64[]
Tlog = Float64[]
HBAR = Float64[]
Wlog = Float64[]

#function that deposits dots in an array based on time
function deposit(L, t, height)
    for i in 1:t
        x = rand(1:L)
        height[x] = height[x] + 1
    end
    return H
end

#function that calculates the average height
function Hbar(H)
    sum = 0
    for i in 1:length(H)
        sum = H[i] + sum
    end
    Hbar = sum / length(H)
    return Hbar
end

#function that calculates the average height^2
function Hbar2(H)
    sum = 0
    for i in 1:length(H)
        sum = H[i]^2 + sum
    end
    Hbar2 = sum / length(H)
    return Hbar2
end

#function that calculates W
function W_gen(H)
    hbar = Hbar(H)
    hbar2 = Hbar2(H)
    W = sqrt(hbar2 - hbar ^ 2)
    return W
end

#loop that calculates Hbar and W for different times
for i in 1:100
    global t = t + i * count / 100
    global H = deposit(200, t, H)
    hbar = Hbar(H)
    w = W_gen(H)
    push!(T, float(t))
    push!(Tlog, float(log(t)))
    push!(HBAR, float(hbar))
    push!(Wlog, float(log(w)))
end

#fitting a line on the Data
#fh = fit(Tlog, Wlog, 1) #Where fh will be the fitted polynomial

#final touches and plotting
#scatter(Tlog, Wlog,
#    markercolor = :blue,
#    markersize = 3,
#    markeralpha = 1,
#    background = :black,
#    markerstrokealpha = 0,
#    title = "Log(W) based on Log(T)",
#    label = "Data",
#    dpi = 500
#)
#
#plot!(fh, extrema(Tlog)..., label="Linear Fit (beta = 0.728)")

fh = fit(T, HBAR, 2)
scatter(T, HBAR,
    markercolor = :blue,
    markersize = 3,
    markeralpha = 1,
    background = :black,
    markerstrokealpha = 0,
    title = "Hbar based on t",
    label = "Data",
    dpi = 500
)

plot!(fh, extrema(T)..., label="Quadratic Fit")