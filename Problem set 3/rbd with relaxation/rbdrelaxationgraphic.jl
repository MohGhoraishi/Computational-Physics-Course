using LinearAlgebra
using StatsPlots
using Colors
gr()

#initial values
L = 200 #number of bins
revert_count = 20000 #number of dots placed before changing color
h0 = zeros(L)
#function that deposits revert_count amount of dots
function deposit(L, n, H)
    deltaheight = zeros(L)
    for i in 1:n
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

#creating four arrays each with a random distribution
H1 = deposit(L, revert_count, h0)
H2 = deposit(L, revert_count, H1)
H3 = deposit(L, revert_count, H2)
H4 = deposit(L, revert_count, H3)

#Final touches and plotting using StatsPlots.jl
s = raw"number of points in each color=" * "$revert_count"
groupedbar([H4 H3 H2 H1], bar_position = :stack, bar_width = 1,
colour = [:plum2 :blueviolet :darkorchid4 :purple4], 
linecolor = :transparent,
background = :black,
title = s,
legend = false,
dpi = 500
)
