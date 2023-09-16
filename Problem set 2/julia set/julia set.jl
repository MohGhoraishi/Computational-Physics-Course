using LinearAlgebra
using Plots
using Colors
gr()

#initial values
width = 2000
height = 1333
c = -0.4 + 0.6im

#function that returns a color based on the result of the transformation done on a position
function julia_color(x, y, width, height, c)    
    z = ((y/width)*3 - 1.5) + ((x/height)*3 - 1.5)im #transformations have been applied to the coordinates to center and scale the fractal   
    for i in -255:255
        z = z^2 + c
        if abs(z) >= 2
            return i        
        end    
    end    
    return -255 #if none of the above conditions are met we want the darkest color of the scheme
end

#function that creates an array of the colors of each coordinate
function julia_set(height, width, c)    
        [julia_color(x, y, width, height, c) for x = 1:height, y = 1:width]
end

#calling the functions to create a set of data, final touches and plotting
set = julia_set(height, width, c)
title = raw"c=" * "$c"
heatmap(set, size=(width,height), color = :magma, title = title, dpi = 500)

