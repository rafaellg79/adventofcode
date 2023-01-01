using DelimitedFiles

let input = readdlm("input", ',', Int)
    # Part 1
    faces = size(input, 1)*6
    for i in 1:size(input, 1)
        for j in 1:i
            if sum(abs(input[i, k] - input[j, k]) for k in 1:size(input, 2)) == 1
                faces -= 2
            end
        end
    end
    display(faces)
    
    # Part 2
    A = zeros(Int, 22,22,22)
    for i = 1:size(input, 1)
        A[(input[i, :].+2)...] = 1
    end
    
    seed = CartesianIndex(1,1,1)
    next = [seed]
    visited = Set{CartesianIndex{3}}()
    neighborhood = [CartesianIndex(0,0,1);CartesianIndex(0,0,-1);
                    CartesianIndex(0,1,0);CartesianIndex(0,-1,0);
                    CartesianIndex(1,0,0);CartesianIndex(-1,0,0)
                   ]
    exterior = 0
    # bfs
    while !isempty(next)
        I = popfirst!(next)
        if checkbounds(Bool, A, I) && !(I in visited)
            if A[I] == 0
                append!(next, map(δ->I+δ, neighborhood))
                push!(visited, I)
            else
                exterior += 1
            end
        end
    end
    
    display(exterior)
end