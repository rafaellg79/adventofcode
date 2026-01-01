NEIGHBORS = deleteat!(vec([CartesianIndex(i, j) for i in -1:1, j in -1:1]), 5)

# Part 1

let lines = readlines("input")
    grid = Array{Int}(undef, length(lines), length(lines[1]))
    for I in CartesianIndices(grid)
        grid[I] = lines[I[1]][I[2]] == '@'
    end
    
    accessible = 0
    
    for I in CartesianIndices(grid)
        n = 0
        if grid[I] == 0
            continue
        end
        for neighbor in NEIGHBORS
            if checkbounds(Bool, grid, I+neighbor) && grid[I+neighbor] > 0
                n += 1
            end
        end
        if n < 4
            accessible += 1
        end
    end
    display(accessible)
end

# Part 2

let lines = readlines("input")
    grid = Array{Int}(undef, length(lines), length(lines[1]))
    rolls = Set{CartesianIndex{2}}()
    for I in CartesianIndices(grid)
        grid[I] = lines[I[1]][I[2]] == '@'
        if grid[I] == 1
            push!(rolls, I)
        end
    end
    
    total_rolls = length(rolls)
    
    accessible = 0
    
    num_rolls = 9
    
    while num_rolls != length(rolls)
        num_rolls = length(rolls)
        for I in rolls
            n = 0
            for neighbor in NEIGHBORS
                if checkbounds(Bool, grid, I+neighbor) && grid[I+neighbor] > 0
                    n += 1
                end
            end
            if n < 4
                grid[I] = -1
                delete!(rolls, I)
            end
        end
    end
    display(total_rolls - num_rolls)
end