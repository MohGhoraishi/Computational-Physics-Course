using LinearAlgebra
using Plots
using Colors
gr()

L = 100 #number of rows
M0 = zeros(L+2, L+2) #the extra two rows and columns are to mitigate problems on the edge
P = 63 #Probability

#assigning 1 to the left edge and a large number to the right edge
Large = L^2 + L #Just a large number that wouldn't be used as an index value in the matrix
for i in 2:L+1
    M0[i, 2] = 1
    M0[i, L+1] = Large  
end

for i in 1:L+2
    M0[i, 1] = 0
    M0[i, L+2] = 0
    M0[1, i] = 0
    M0[L+2, i] = 0
end


#Assigning values at random to the matrix
counter = 2
for i in 3:L+1
    for j in 2:L #ignores the edge
        num = rand(1:100)
        if num < P
            M0[i, j] = counter
            global counter = counter + 1
        end 
    end
end

#function that applies the coloring algorithm to the matrix
function Coloring(M)
    for i in 2:L+1
        for j in 2:L+1
            if M[i, j] != 0
                M[i, j], neigh = neighbourcheck(M, i, j)
                if length(neigh) != 0
                    M = neighbourmin(M, neigh)
                end
            end
        end
    end
    return M
end

#function that checks the neighboring cells of an element and returns the nonzero neighbours and the smallest neighbour
function neighbourcheck(Matrix, a, b)
    num = Matrix[a, b] #the number that will be returned as the final element value
    nonzero = [] #array holding the nonzero neighbours
    if Matrix[a-1, b] != 0
        push!(nonzero, Matrix[a-1, b])
    end
    if Matrix[a, b-1] != 0
        push!(nonzero, Matrix[a, b-1])
    end
    if Matrix[a+1, b] != 0
        push!(nonzero, Matrix[a+1, b])
    end
    if Matrix[a, b+1] != 0
        push!(nonzero, Matrix[a, b+1])
    end
    if length(nonzero) != 0
        num = minimum(nonzero)
    end
    return num, nonzero
end

#function that sets the numbers to the minimum neighbour
function neighbourmin(Matrix, nonzero)
    min = minimum(nonzero)
    for i in 1:L+1
        for j in 1:L+1
            if Matrix[i, j] in nonzero
                Matrix[i, j] = min
            end
        end
    end
    return Matrix
end

Mcolored = Coloring(M0)

for i in 2:L+1
    if Mcolored[i, L+1] == 1
        global s = raw"L = " * "$L" * ", P = " * "$P" * " Percolation happened"
        break
    end
    global s = raw"L = " * "$L" * ", P = " * "$P" * " Percolation didn't happen"
end

for i in 1:L+2
    for j in 1:L+2
        if Mcolored[i, j] == 1
            Mcolored[i, j] = Large * 2
        end   
    end
end

#Plotting using a heatmap
 heatmap(Mcolored,
    color = :thermal,
    dpi = 500,
    aspect_ratio = 1,
    title = s,
    background = :black,)