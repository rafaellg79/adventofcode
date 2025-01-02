function findall_hiking_trails(topographic_map, trailhead)
    dirs = [CartesianIndex(-1, 0) CartesianIndex(0, -1) CartesianIndex(1, 0) CartesianIndex(0, 1)]
    paths = Set{CartesianIndex{2}}()
    push!(paths, trailhead)
    next = Set{CartesianIndex{2}}()
    for i = 1:9
        for current in paths
            for dir in dirs
                if get(topographic_map, current + dir, -1) == i
                    push!(next, current+dir)
                end
            end
        end
        paths = next
        next = Set{CartesianIndex}()
    end
    return length(paths)
end

# Part 1

let lines = readlines("input")
    matrix = transpose(parse.(Int, hcat(collect.(lines)...)))
    trailheads = findall(iszero, matrix)
    s = 0
    for trailhead in trailheads
        s += findall_hiking_trails(matrix, trailhead)
    end
    display(s)
end

# Part 2

function find_hiking_trail_rating(topographic_map, trailhead)
    dirs = [CartesianIndex(-1, 0) CartesianIndex(0, -1) CartesianIndex(1, 0) CartesianIndex(0, 1)]
    paths = Dict{CartesianIndex{2}, Int}()
    paths[trailhead] = 1
    next = Dict{CartesianIndex{2}, Int}()
    for i = 1:9
        for current in keys(paths)
            for dir in dirs
                if get(topographic_map, current + dir, -1) == i
                    next[current+dir] = get(next, current + dir, 0) + paths[current]
                end
            end
        end
        paths = next
        next = Dict{CartesianIndex{2}, Int}()
    end
    return sum(values(paths))
end

let lines = readlines("input")
    matrix = transpose(parse.(Int, hcat(collect.(lines)...)))
    trailheads = findall(iszero, matrix)
    s = 0
    for trailhead in trailheads
        s += find_hiking_trail_rating(matrix, trailhead)
    end
    display(s)
end