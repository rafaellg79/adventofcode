function bfs(cost_matrix, seed, steps_range)
    next = Tuple{CartesianIndex{2}, CartesianIndex{2}}[(seed, CartesianIndex(1, 0)), (seed, CartesianIndex(0, 1))]
    
    dist = fill(typemax(Int), size(cost_matrix)..., 2)
    dist[1, 1, 1] = 0
    dist[1, 1, 2] = 0
    while !isempty(next)
        pos, dir = popfirst!(next)
        orientation = 1 + abs(dir[1])
        delta_orientation = 3-orientation
        for delta in (CartesianIndex(dir[2], dir[1]), CartesianIndex(-dir[2], -dir[1]))
            if !checkbounds(Bool, dist, pos + steps_range[1] * delta, delta_orientation)
                continue
            end
            cost = sum(Int(cost_matrix[pos + d*delta]) for d in 1:(steps_range[1]-1); init=0)
            for k = steps_range
                next_pos = pos + k*delta

                if !checkbounds(Bool, dist, next_pos, delta_orientation)
                    break
                end
                cost += cost_matrix[next_pos]
                if (dist[pos, orientation] + cost < dist[next_pos, delta_orientation])
                    dist[next_pos, delta_orientation] = dist[pos, orientation] + cost
                    push!(next, (next_pos, delta))
                end
            end
        end
    end
    return min(dist[end, end, 1], dist[end, end, 2])
end

# Part 1

let lines = readlines("input")
    cost_matrix = reduce(vcat, permutedims.(collect.(lines))).-'0'
    display(bfs(cost_matrix, CartesianIndex(1, 1), 1:3))
end

# Part 2

let lines = readlines("input")
    cost_matrix = reduce(vcat, permutedims.(collect.(lines))).-'0'
    display(bfs(cost_matrix, CartesianIndex(1, 1), 4:10))
end