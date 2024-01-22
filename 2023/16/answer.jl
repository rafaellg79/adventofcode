# dir is an integer such that:
# 1 = right
# 2 = up
# 4 = left
# 8 = down
const dir_map = CartesianIndex[CartesianIndex(0, 1) CartesianIndex(-1, 0) CartesianIndex(0, 0) CartesianIndex(0, -1) CartesianIndex(0, 0) CartesianIndex(0, 0) CartesianIndex(0, 0) CartesianIndex(1, 0)]
const slash_map = Int[2 1 0 8 0 0 0 4]
const backslash_map = Int[8 4 0 2 0 0 0 1]

function find_next_pos!(rays, tile, pos, dir)
    if tile == '.' ||
      (tile == '|' && (dir & (2 | 8)) != 0) ||
      (tile == '-' && (dir & (1 | 4)) != 0)
        rays[1] = (pos + dir_map[dir], dir)
        return 1
    elseif tile == '|'
        rays[1] = (pos+dir_map[2], 2)
        rays[2] = (pos+dir_map[8], 8)
        return 2
    elseif tile == '-'
        rays[1] = (pos+dir_map[1], 1)
        rays[2] = (pos+dir_map[4], 4)
        return 2
    elseif tile == '/'
        rays[1] = (pos+dir_map[slash_map[dir]], slash_map[dir])
        return 1
    elseif tile == '\\'
        rays[1] = (pos+dir_map[backslash_map[dir]], backslash_map[dir])
        return 1
    end
    return 0
end

function dfs(tiles, seed_pos, seed_dir; rays=Array{Tuple{CartesianIndex{2}, Int8}}(undef, 10000), visited=zeros(Int8, size(tiles)))
    len = 1
    rays[len] = (seed_pos, seed_dir)
    while len > 0
        pos, dir = rays[len]
        len -= 1
        if !checkbounds(Bool, tiles, pos)
            continue
        end
        if visited[pos] & dir != 0
            continue
        else
            visited[pos] |= dir
        end
        
        len += find_next_pos!(view(rays, len+1:len+2), tiles[pos], pos, dir)
    end
    return visited
end

# Part 1

let lines = readlines("input")
    tiles = reduce(vcat, permutedims.(collect.(lines)))
    visited = dfs(tiles, CartesianIndex(1, 1), 1)
    
    display(count(!iszero, visited))
end

# Part 2

let lines = readlines("input")
    tiles = reduce(vcat, permutedims.(collect.(lines)))
    
    max_energy = 0
    rays = Array{Tuple{CartesianIndex{2}, Int8}}(undef, 10000)
    visited = zeros(Int8, size(tiles))

    for start_dir in [1, 2, 4, 8]
        border = nothing
        if start_dir == 1
            border = CartesianIndices(tiles)[:, 1]
        elseif (start_dir == 4)
            border = CartesianIndices(tiles)[:, end]
        elseif (start_dir == 2)
            border = CartesianIndices(tiles)[end, :]
        elseif (start_dir == 8)
            border = CartesianIndices(tiles)[1, :]
        end
        for start_pos in border
            visited .= 0
            dfs(tiles, start_pos, start_dir; rays=rays, visited=visited)
            max_energy = max(max_energy, count(!iszero, visited))
        end
    end
    
    display(max_energy)
end