using LinearAlgebra
using StatsPlots
using Colors
gr()

#initial values
L = 200 #number of bins
revert_count = 5000 #number of dots placed before changing color
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

#calling the function and computing the coordinates of the dots in four steps
newx1, newy1, maxh1 = deposit(L, revert_count, maxh)
newx2, newy2, maxh2 = deposit(L, revert_count, maxh1)
newx3, newy3, maxh3 = deposit(L, revert_count, maxh2)
newx4, newy4, maxh4 = deposit(L, revert_count, maxh3)

#plotting
scatter(newx1, newy1,
    marker = :square,
    markeralpha = 1,
    markersize = 1.1, #marker size for the square to be 1x1 in this specific plot size
    markercolor = :purple4,
    markerstrokewidth = 0,
    markerstrokealpha = 0,
    background = :black,
    xlims=(0, L), 
    ylims=(0, revert_count / L * 2 * 4),
    aspect_ratio = 1,
    legend = false,
    dpi = 1000
)

scatter!(newx2, newy2,
    marker = :square,
    markeralpha = 1,
    markersize = 1.1,
    markercolor = :darkorchid4,
    markerstrokewidth = 0,
    markerstrokealpha = 0,
)

scatter!(newx3, newy3,
    marker = :square,
    markeralpha = 1,
    markersize = 1.1,
    markercolor = :blueviolet,
    markerstrokewidth = 0,
    markerstrokealpha = 0,
)
s = raw"number of points in each color=" * "$revert_count"
scatter!(newx4, newy4,
    marker = :square,
    markeralpha = 1,
    markersize = 1.1,
    markercolor = :plum2,
    markerstrokewidth = 0,
    markerstrokealpha = 0,
)