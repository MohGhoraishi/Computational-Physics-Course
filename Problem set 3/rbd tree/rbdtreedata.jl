using LinearAlgebra
using StatsPlots
using Colors
gr()

#initial values
L = 500 #number of bins
n = 100000 #number of dots place
maxh = zeros(L) #max height of each bin
maxh[Int(L / 2)] = 1 #putting a dot in the middle bin

#function that deposits dots into bins while obeying the sidesticking rule
function deposit(L, n, hmax)
    newx = []
    newy = []
    for i in 1:n
        num = rand(2:L - 1) #used to mitigate boundary problems
        if (hmax[num + 1] != 0) || (hmax[num] != 0) || (hmax[num - 1] != 0)
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
    end
    return newx, newy, hmax
end
X, Y, h = deposit(L, n, maxh)
height = Float64[]
width = Float64[]

#loop that calculates the max width of each row based on height for all available heights
for i in 3:maximum(h)
    row = []
    for j in 1:length(Y)
        if Y[j] == i
            push!(row, X[j])
        end
    end
    delta = maximum(row) - minimum(row)
    push!(height, i)
    push!(width, delta)
end

#Final touches and plotting
scatter(height, width,
    markercolor = :blue,
    markersize = 3,
    markeralpha = 1,
    background = :black,
    markerstrokealpha = 0,
    title = "Maximum width based on height For \n 100000 dots and L = 500",
    label = "Data",
    dpi = 500
)
