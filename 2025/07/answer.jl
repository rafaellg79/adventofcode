function split(grid, pos, dir, hits, propagate)
    perp1 = CartesianIndex(dir[2], -dir[1])
    perp2 = CartesianIndex(dir[2], dir[1])
    return propagate(grid, pos+perp1, dir, hits) + propagate(grid, pos+perp2, dir, hits)
end

# Part 1
function move(grid, pos, dir, hits)
    if !checkbounds(Bool, grid, pos)
        return 0
    elseif grid[pos] == '^'
        if hits[pos] == 0
            hits[pos] = 1 + split(grid, pos, dir, hits, move)
            return hits[pos]
        end
        return 0
    else
        return move(grid, pos+dir, dir, hits)
    end
end

let lines = readlines("input")
    grid = permutedims(hcat(collect.(lines)...))
    start = findfirst(==('S'), grid)
    hits = zeros(Int, size(grid))
    
    dir = CartesianIndex(1, 0)
    
    n = move(grid, start, dir, hits)
    
    display(n)
end

# Part 2

function move2(grid, pos, dir, hits)
    if !checkbounds(Bool, grid, pos)
        return 1
    elseif grid[pos] == '^'
        if hits[pos] == 0
            hits[pos] = split(grid, pos, dir, hits, move2)
        end
        return hits[pos]
    else
        return move2(grid, pos+dir, dir, hits)
    end
end

let lines = readlines("input")
    grid = permutedims(hcat(collect.(lines)...))
    start = findfirst(==('S'), grid)
    hits = zeros(Int, size(grid))
    
    dir = CartesianIndex(1, 0)
    
    n = move2(grid, start, dir, hits)
    
    display(n)
end