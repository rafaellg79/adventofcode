const DIR_MAP = Dict(1 => CartesianIndex(-1, 0), 2 => CartesianIndex(0, 1), 4 => CartesianIndex(1, 0), 8 => CartesianIndex(0, -1))
const INV_DIR_MAP = Dict(CartesianIndex(-1, 0) => 1, CartesianIndex(0, 1) => 2, CartesianIndex(1, 0) => 4, CartesianIndex(0, -1) => 8)

# Part 1

function step(lab, guard, dir)
    if !checkbounds(Bool, lab, guard+dir)
        return (guard, dir)
    end
    if lab[guard + dir] == -1
        return (guard, CartesianIndex(dir[2], -dir[1]))
    end
    return (guard + dir, dir)
end

function find_route(lab, guard, dir)
    route = zeros(Int, size(lab))
    while (route[guard] & INV_DIR_MAP[dir]) == 0
        route[guard] |= INV_DIR_MAP[dir]
        (guard, dir) = step(lab, guard, dir)
    end
    return route
end

let lines = readlines("input")
    lab = Array{Int}(undef, length(lines), length(lines[1]))
    guard = 0
    
    for i in 1:length(lines), j in 1:length(lines[i])
        if lines[i][j] == '^'
            guard = CartesianIndex(i, j)
        elseif lines[i][j] == '#'
            lab[i, j] = -1
        else
            lab[i, j] = 0
        end
    end
    
    display(count(>(0), find_route(lab, guard, CartesianIndex(-1, 0))))
end

# Part 2

function has_loop_to_right(route, lab, guard, dir)
    while (route[guard] & INV_DIR_MAP[dir]) == 0
        route[guard] |= INV_DIR_MAP[dir]
        (new_guard, new_dir) = step(lab, guard, dir)
        if new_guard == guard && new_dir == dir
            return false
        end
        guard = new_guard
        dir = new_dir
    end
    return true
end

function find_loops(lab, guard, dir)
    starting_pos = guard
    loops = falses(size(lab))
    route = zeros(Int, size(lab))
    route_copy = copy(route)
    while (route[guard] & INV_DIR_MAP[dir]) == 0
        route_copy .= route
        if guard+dir != starting_pos && get(lab, guard+dir, -1) != -1 && route[guard+dir] == 0
            lab[guard+dir] = -1
            if has_loop_to_right(route_copy, lab, guard, dir)
                loops[guard+dir] = true
            end
            lab[guard+dir] = 0
        end
        route[guard] |= INV_DIR_MAP[dir]
        (guard, dir) = step(lab, guard, dir)
    end
    return loops
end

let lines = readlines("input")
    lab = Array{Int}(undef, length(lines), length(lines[1]))
    guard = CartesianIndex(0, 0)
    
    for i in 1:length(lines), j in 1:length(lines[i])
        if lines[i][j] == '^'
            guard = CartesianIndex(i, j)
        elseif lines[i][j] == '#'
            lab[i, j] = -1
        else
            lab[i, j] = 0
        end
    end
    
    display(count(find_loops(lab, guard, CartesianIndex(-1, 0))))
end