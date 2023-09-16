using LinearAlgebra
using StatsPlots
using Colors
gr()

#initial values
L = 200 #number of bins
revert_count = 20000 #number of dots placed before changing color

#function that deposits revert_count amount of dots
function deposit(L, n)
    H = zeros(L) 
    for i in 1:n
        x = rand(1:L)
        H[x] = H[x] + 1
    end
    return H
end

#creating four arrays each with a random distribution
H1 = deposit(L, revert_count)
H2 = deposit(L, revert_count)
H3 = deposit(L, revert_count)
H4 = deposit(L, revert_count)

#Final touches and plotting using StatsPlots.jl
s = raw"number of points in each color=" * "$revert_count"
groupedbar([H1 H2 H3 H4], bar_position = :stack, bar_width = 1,
colour = [:plum2 :blueviolet :darkorchid4 :purple4], 
linecolor = :transparent,
background = :black,
title = s,
legend = false,
dpi = 500
)
