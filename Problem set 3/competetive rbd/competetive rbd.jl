using LinearAlgebra
using Colors
gr()

#initial values
L = 200 #number of bins
n = 2000 #number of dots placed
angle = 75 #angle in degrees from the horizon line
theta = angle * pi / 180 #angle in radians
h = zeros(L) #array of heights

#function that deposits the dots
function deposit(L, n, h)
    for i in 1:n
        num = rand(1:L)
        for j in 1:num
            if (num - j) * tan(theta) <= h[j]
                h[j] = h[j] + 1
                break
            end            
        end
    end
    return h
end

height = deposit(L, n, h)

#final touches and plotting
s = raw"Theta = " * "$angle"
bar(height, 
colour = :plum2, 
linecolor = :transparent,
background = :black,
title = s,
legend = false,
dpi = 500
)