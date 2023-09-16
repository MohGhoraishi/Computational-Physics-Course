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

#function that deposits dots in an array based on time
function deposit(L, t, H)
    deltaheight = zeros(L)
    for i in 1:t
        x = rand(1:L)
        if x == 1
            if (deltaheight[1] + H[1] <= deltaheight[L] + H[L]) && (deltaheight[1] + H[1] <= deltaheight[2] + H[2])
                deltaheight[1] = deltaheight[1] + 1
            elseif deltaheight[L] + H[L] <= deltaheight[2] + H[2]
                deltaheight[L] = deltaheight[L] + 1
            elseif deltaheight[L] + H[L] == deltaheight[2] + H[2] #needed for the rare occaision where the two sides have the same height
                k = rand([1, 0])
                if k == 0
                    deltaheight[L] = deltaheight[L] + 1
                else
                    deltaheight[2] = deltaheight[2] + 1
                end  
            else
                deltaheight[2] = deltaheight[2] + 1
            end
        elseif x == L
            if (deltaheight[L] + H[L] <= deltaheight[1] + H[1]) && (deltaheight[L] + H[L] <= deltaheight[L - 1] + H[L - 1])
                deltaheight[L] = deltaheight[L] + 1
            elseif deltaheight[1] + H[1] <= deltaheight[L - 1] + H[L - 1]
                deltaheight[1] = deltaheight[1] + 1
            elseif deltaheight[1] + H[1] == deltaheight[L - 1] + H[L - 1]
                k = rand([1, 0])
                if k == 0
                    deltaheight[L - 1] = deltaheight[L - 1] + 1
                else
                    deltaheight[1] = deltaheight[1] + 1
                end  
            else
                deltaheight[L - 1] = deltaheight[L - 1] + 1
            end
        else
            if (deltaheight[x] + H[x] <= deltaheight[x + 1] + H[x + 1]) && (deltaheight[x] + H[x] <= deltaheight[x - 1] + H[x - 1])
                deltaheight[x] = deltaheight[x] + 1
            elseif deltaheight[x + 1] + H[x + 1] <= deltaheight[x - 1] + H[x - 1]
                deltaheight[x + 1] = deltaheight[x + 1] + 1
            elseif deltaheight[x + 1] + H[x + 1] == deltaheight[x - 1] + H[x - 1]
                k = rand([1, 0])
                if k == 0
                    deltaheight[x + 1] = deltaheight[x + 1] + 1
                else
                    deltaheight[x - 1] = deltaheight[x - 1] + 1
                end  
            else
                deltaheight[x - 1] = deltaheight[x - 1] + 1
            end
        end
    end
    return deltaheight
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