const dir_map = Dict(CartesianIndex(-1, 0) => 1, CartesianIndex(1, 0) => 2, CartesianIndex(0, -1) => 3, CartesianIndex(0, 1) => 4)

# Part 1

let lines = readlines("input")
    maze = permutedims(hcat(collect.(lines)...))
    
    start_pos = findfirst(==('S'), maze)
    end_pos = findfirst(==('E'), maze)
    start_dir = CartesianIndex(0, 1)
    
    next = [(start_pos, start_dir)]
    weights = fill(typemax(Int), size(maze)..., 4)
    weights[start_pos, 4] = 0
    
    while !isempty(next)
        pos, dir = pop!(next)
        perp = CartesianIndex(-dir[2], dir[1])
        if maze[pos+dir] != '#' &&  weights[pos, dir_map[dir]]+1 < weights[pos+dir, dir_map[dir]]
            weights[(pos+dir), dir_map[dir]] = weights[pos, dir_map[dir]]+1
            push!(next, (pos+dir, dir))
        end
        if weights[pos, dir_map[dir]]+1000 < weights[pos, dir_map[perp]]
            weights[pos, dir_map[perp]] = weights[pos, dir_map[dir]]+1000
            push!(next, (pos, perp))
        end
        if weights[pos, dir_map[dir]]+1000 < weights[pos, dir_map[-perp]]
            weights[pos, dir_map[-perp]] = weights[pos, dir_map[dir]]+1000
            push!(next, (pos, -perp))
        end
    end
    
    display(minimum(weights[end_pos, :]))
end

# Part 2

let lines = readlines("input")
    maze = permutedims(hcat(collect.(lines)...))
    
    start_pos = findfirst(==('S'), maze)
    end_pos = findfirst(==('E'), maze)
    start_dir = CartesianIndex(0, 1)
    
    next = [(start_pos, start_dir)]
    weights = fill(typemax(Int), size(maze)..., 4)
    weights[start_pos, 4] = 0
    
    while !isempty(next)
        pos, dir = pop!(next)
        perp = CartesianIndex(-dir[2], dir[1])
        if maze[pos+dir] != '#' &&  weights[pos, dir_map[dir]]+1 < weights[pos+dir, dir_map[dir]]
            weights[(pos+dir), dir_map[dir]] = weights[pos, dir_map[dir]]+1
            push!(next, (pos+dir, dir))
        end
        if weights[pos, dir_map[dir]]+1000 < weights[pos, dir_map[perp]]
            weights[pos, dir_map[perp]] = weights[pos, dir_map[dir]]+1000
            push!(next, (pos, perp))
        end
        if weights[pos, dir_map[dir]]+1000 < weights[pos, dir_map[-perp]]
            weights[pos, dir_map[-perp]] = weights[pos, dir_map[dir]]+1000
            push!(next, (pos, -perp))
        end
    end
    
    best = minimum(weights[end_pos, :])
    next = filter(x -> weights[x[1], dir_map[x[2]]]==best, [(end_pos, CartesianIndex(-1, 0)), (end_pos,  CartesianIndex(1, 0)), (end_pos, CartesianIndex(0, -1)), (end_pos, CartesianIndex(0, 1))])
    
    while !isempty(next)
        pos, dir = pop!(next)
        perp = CartesianIndex(-dir[2], dir[1])
        if maze[pos-dir] != '#' &&  weights[pos-dir, dir_map[dir]]+1 == weights[pos, dir_map[dir]]
            maze[pos-dir] = 'O'
            push!(next, (pos-dir, dir))
        end
        if weights[pos, dir_map[perp]]+1000 == weights[pos, dir_map[dir]]
            push!(next, (pos, perp))
        end
        if weights[pos, dir_map[-perp]]+1000 == weights[pos, dir_map[dir]]
            push!(next, (pos, -perp))
        end
    end
    
    display(count(==('O'), maze)+1)
end