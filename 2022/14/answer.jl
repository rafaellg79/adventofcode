let input = readlines("input")
    paths = map.(s -> Tuple{Int, Int}(parse.(Int, split(s, ","))), split.(input, " -> "))
    A = zeros(Int, 1000, 1000)
    
    for path in paths
        for (a, b) in zip(path, path[2:end])
            dir = sign.(b.-a)
            rock = a
            while rock != b
                A[rock...] = 1
                rock = rock .+ dir
            end
            A[rock...] = 1
        end
    end
    
    function simulate(A::Matrix{Int})
        sand = (500, 0)
        while true
            if sand[2] >= size(A, 2)
                return false
            elseif A[sand[1], sand[2]+1] == 0
                sand = (sand[1], sand[2]+1)
            elseif A[sand[1]-1, sand[2]+1] == 0
                sand = (sand[1]-1, sand[2]+1)
            elseif A[sand[1]+1, sand[2]+1] == 0
                sand = (sand[1]+1, sand[2]+1)
            else
                break
            end
        end
        return sand
    end
    
    # Part 1
    sand_count = 0
    while true
        s = simulate(A)
        if s == false
            break
        else
            A[s...] = 2
            sand_count+=1
        end
    end
    display(sand_count)
    
    # Part 2
    floor_y = maximum(a -> maximum(last, a), paths)+2
    A[:, floor_y] .= 1
    while true
        s = simulate(A)
        if s == (500, 0)
            sand_count += 1
            break
        else
            A[s...] = 2
            sand_count+=1
        end
    end
    display(sand_count)
end