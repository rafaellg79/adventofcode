using SparseArrays

# Part 1

#=function dfs(adj, start, finish)
    visited = Set()
    next = Set(start)
    while !isempty(next)
        node = pop!(next)
        push!(visited, node)
        for i in 1:size(adj, 2)
            if adj[node, i] == 1 && !(i in visited)
                push!(next, i)
            end
        end
    end
end=#

function count_reachable(adj, start, finish)
    if start == finish
        return 1
    end
    n = 0
    for i in 1:size(adj, 2)
        if adj[start, i] == 1
            n += count_reachable(adj, i, finish)
        end
    end
    return n
end

let lines = readlines("input")
    nodes_label = Dict()
    for line in lines
        nodes = split(line, ' ')
        nodes[1] = nodes[1][1:end-1]
        for node in nodes
            if !haskey(nodes_label, node)
                nodes_label[node] = length(keys(nodes_label))+1
            end
        end
    end
    
    N = length(keys(nodes_label))
    adjacency_matrix = zeros(Int, N, N)
    
    for line in lines
        nodes = split(line, ' ')
        nodes[1] = nodes[1][1:end-1]
        nodes_ind = [nodes_label[node] for node in nodes]
        for node in nodes_ind[2:end]
            adjacency_matrix[nodes_ind[1], node] = 1
        end
    end
    
    you = nodes_label["you"]
    out = nodes_label["out"]
    
    display(count_reachable(adjacency_matrix, you, out))
end

# Part 2

function all_paths(adjacency_matrix, start, finish, dac, fft)
    next = Tuple{Int, Int}[(start, 0)]
    current_path = Int16[]
    n = 0
    sol = Dict((finish, true, true)=>1)
    while !isempty(next)
        node, len = pop!(next)
        while len < length(current_path)
            has_dac = dac in current_path
            has_fft = fft in current_path
            last_node = pop!(current_path)
            
            m = 0
            for neighbor in rowvals(adjacency_matrix[last_node, :])
                m += sol[(neighbor, has_dac || neighbor==dac, has_fft || neighbor==fft)]
            end
            sol[(last_node, has_dac, has_fft)] = m
        end
        
        push!(current_path, node)
        for neighbor in rowvals(adjacency_matrix[node, :])
            key = (neighbor, dac in current_path || neighbor==dac, fft in current_path || neighbor==fft)
            if haskey(sol, key)
                n += sol[key]
            elseif !(neighbor in current_path)
                push!(next, (neighbor, length(current_path)))
            end
        end
    end
    return n
end

let lines = readlines("input")
    nodes_label = Dict()
    for line in lines
        nodes = split(line, ' ')
        nodes[1] = nodes[1][1:end-1]
        for node in nodes
            if !haskey(nodes_label, node)
                nodes_label[node] = length(keys(nodes_label))+1
            end
        end
    end
    
    N = length(keys(nodes_label))
    adjacency_matrix = spzeros(Int, N, N)
    
    for line in lines
        nodes = split(line, ' ')
        nodes[1] = nodes[1][1:end-1]
        nodes_ind = [nodes_label[node] for node in nodes]
        for node in nodes_ind[2:end]
            adjacency_matrix[nodes_ind[1], node] = 1
        end
    end
    
    svr = nodes_label["svr"]
    out = nodes_label["out"]
    dac = nodes_label["dac"]
    fft = nodes_label["fft"]
    
    display(all_paths(adjacency_matrix, svr, out, dac, fft))
end