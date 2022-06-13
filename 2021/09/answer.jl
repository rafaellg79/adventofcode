height_map = parse.(Int, hcat(collect.(readlines("input"))...))

function is_low_point(A::Matrix{Int}, P::CartesianIndex{2})
    neighbors = CartesianIndex.([(0, -1) (0, 1) (-1, 0) (1, 0)])
    return all(neighbor->checkbounds(Bool, A, P+neighbor) ? A[P+neighbor]>A[P] : true, neighbors)
end

low_points = filter((x)->is_low_point(height_map, x), CartesianIndices(height_map))

basins = zeros(Int, length(low_points))

for (i, low_point) in enumerate(low_points)
    next = CartesianIndex[low_point]
    visited = CartesianIndex[]
    while !isempty(next)
        current = pop!(next)
        if current in visited
            continue
        end
        basins[i]+=1
        push!(visited, current)
        neighbors = map(x -> x+current, CartesianIndex.([(0, -1) (0, 1) (-1, 0) (1, 0)]))
        for neighbor_index in neighbors
            if !checkbounds(Bool, height_map, neighbor_index)
                continue
            end
            neighbor_value = height_map[neighbor_index]
            if neighbor_value > height_map[current] && neighbor_value < 9
                push!(next, neighbor_index)
            end
        end
    end
end


display(sum(x -> height_map[x] + 1, low_points))
display(prod(sort(basins; lt= >)[1:3]))