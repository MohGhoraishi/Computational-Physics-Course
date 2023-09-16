using LinearAlgebra
using StatsPlots
using Colors
using Polynomials
using Statistics
gr()

#initial values
L = 100 #number of bins
count = 100000 #number of total dots placed
t = 0 #time that starts at zero and a dot is placed with every unit of time
H = zeros(L) #array that stores the height
T = Float64[]
Tlog = Float64[]
HBAR = Float64[]
Wlog = Float64[]

#function that deposits dots into bins while obeying the sidesticking rule
function deposit(L, n, hmax)
    newx = []
    newy = []
    for i in 1:n
        num = rand(1:L)
        if num == 1
            if (hmax[1] >= hmax[L]) && (hmax[1] >= hmax[2])
                hmax[1] = hmax[1] + 1
                push!(newx, num)
                push!(newy, hmax[1])
            elseif hmax[L] >= hmax[2]
                hmax[1] = hmax[L]
                push!(newx, num)
                push!(newy, hmax[1])
            else
                hmax[1] = hmax[2]
                push!(newx, num)
                push!(newy, hmax[1])
            end
        elseif num == L
            if (hmax[L] >= hmax[L - 1]) && (hmax[L] >= hmax[1])
                hmax[L] = hmax[L] + 1
                push!(newx, num)
                push!(newy, hmax[L])
            elseif hmax[1] >= hmax[L - 1]
                hmax[L] = hmax[1]
                push!(newx, num)
                push!(newy, hmax[L])
            else
                hmax[L] = hmax[L - 1]
                push!(newx, num)
                push!(newy, hmax[L])
            end
        else
            if (hmax[num] >= hmax[num - 1]) && (hmax[num] >= hmax[num + 1])
                hmax[num] = hmax[num] + 1
                push!(newx, num)
                push!(newy, hmax[num])
            elseif hmax[num + 1] >= hmax[num - 1]
                hmax[num] = hmax[num + 1]
                push!(newx, num)
                push!(newy, hmax[num])
            else
                hmax[num] = hmax[num - 1]
                push!(newx, num)
                push!(newy, hmax[num])
            end
            
        end
    end
    return hmax
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

#loop that calculates the average of Hbar and W for different times and over many runs
for i in 1:50
    global t = t + i * count / 50
    hbar = []
    w = []
    for i in 1:100
        global H = deposit(L, t, H)
        push!(hbar, Hbar(H))
        push!(w, W_gen(H))
    end
    hmean = mean(hbar)
    wmean = mean(w)
    push!(T, float(t))
    push!(Tlog, float(log(t)))
    push!(HBAR, float(hmean))
    push!(Wlog, float(log(wmean)))
end

##fitting a line on the Data
#fh = fit(Tlog, Wlog, 1) #Where fh will be the fitted polynomial
##final touches and plotting
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

#plot!(fh, extrema(Tlog)..., label="Linear Fit ($fh)")

fh = fit(T, HBAR, 1)
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

plot!(fh, extrema(T)..., label="Linear Fit ($fh)")