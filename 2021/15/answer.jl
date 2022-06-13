using DelimitedFiles, DataStructures

risk_levels = readlines("input")
risk_levels = parse.(Int, hcat(collect.(risk_levels)...))

function get_neighbors(A::Matrix, ind::CartesianIndex{2})
    return filter(I -> checkbounds(Bool, A, I),
                CartesianIndex{2}[
                 CartesianIndex(ind[1] - 1, ind[2]),
                 CartesianIndex(ind[1] + 1, ind[2]),
                 CartesianIndex(ind[1], ind[2] - 1),
                 CartesianIndex(ind[1], ind[2] + 1)
                ])
end

function dijkstra(weights)
    min_dist = fill(typemax(Int), size(weights))
    min_dist[1, 1] = 0
    
    visited_nodes = Set(CartesianIndex{2}[])
    next = PriorityQueue{CartesianIndex{2}, Int}()
    next[CartesianIndex(1, 1)] = 0

    while !isempty(next)
        node = dequeue!(next)
        weight = min_dist[node]
        push!(visited_nodes, node)
        
        for neighbor in get_neighbors(weights, node)
            neighbor_dist = weight + weights[neighbor]
            if neighbor_dist < min_dist[neighbor]
                min_dist[neighbor] = neighbor_dist
            end
            
            if !(neighbor in visited_nodes)
                next[neighbor] = min_dist[neighbor]
            end
        end
    end
    
    return last(min_dist)
end

risk_levels_expanded = zeros(Int, size(risk_levels) .* 5)

for i = 0:4, j = 0:4
    h, w = size(risk_levels)
    offset_h, offset_w = size(risk_levels) .* (i, j)
    for y = 1:h, x = 1:w
        risk_levels_expanded[y + offset_h, x + offset_w] = risk_levels[y, x] + (i + j)
        if risk_levels_expanded[y + offset_h, x + offset_w] > 9
            risk_levels_expanded[y + offset_h, x + offset_w] -= 9
        end
    end
end

display(dijkstra(risk_levels))
display(dijkstra(risk_levels_expanded))