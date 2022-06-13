using DelimitedFiles, StatsBase

edges = readdlm("input", '-')

vert_index = Dict{String, Int}()
big_caves = Set{Int}()
for v in edges
    if !haskey(vert_index, v)
        i = length(vert_index) + 1
        vert_index[v] = i
        if uppercase(v) == v
            push!(big_caves, i)
        end
    end
end

edges = map(v -> vert_index[v], edges)
edges = edges[:, 1] .=> edges[:, 2]

adjacency_list = Vector{Int}[Int[] for i in 1:length(vert_index)]
for e in edges
    u, v = e[1], e[2]
    push!(adjacency_list[u], v)
    push!(adjacency_list[v], u)
end

function traversal(adjacency_list, source, target, test)
    iterator = [(-1, source)]
    path_buffer = fill(-1, 1000)
    total_paths = 0
    
    while !isempty(iterator)
        previous, current = pop!(iterator)
        
        path = @view path_buffer[1:previous]
        
        if current == target
            total_paths += 1
            continue
        end
        
        if test(current, path, source)
            path_buffer[length(path)+1] = current
            append!(iterator, tuple.(length(path)+1, adjacency_list[current]))
        end
    end
    
    return total_paths
end

s, e = vert_index["start"], vert_index["end"]

display(traversal(adjacency_list, s, e, (current, path, source) -> current ∉ path || current ∈ big_caves))
display(traversal(adjacency_list, s, e, (current, path, source) -> current ∉ path || current ∈ big_caves || (current != source && count(==(mode(filter((u) -> u ∉ big_caves, path))), path) < 2)))



#= faster implementation for part 2
# doesn't need mode from StatsBase
function traversal(adjacency_list, source, target)
    iterator = [(-1, source)]
    path_buffer = fill(-1, 1000)
    total_paths = 0
    repeated = -1
    
    while !isempty(iterator)
        previous, current = pop!(iterator)
        
        path = @view path_buffer[1:previous]
        if repeated > previous
            repeated = -1
        end
        
        if current == target
            total_paths += 1
            continue
        end
        
        if current ∉ path || current ∈ big_caves
            path_buffer[length(path)+1] = current
            append!(iterator, tuple.(length(path)+1, adjacency_list[current]))
        elseif current ∈ path && current != source && repeated < 0
            path_buffer[length(path)+1] = current
            append!(iterator, tuple.(length(path)+1, adjacency_list[current]))
            repeated = length(path)+1
        end
    end
    
    return total_paths
end
=#