function parse_input(lines, is_starting_node, is_finishing_node)
    moves = falses(length(lines[1]))
    for i in eachindex(moves)
        moves[i] = lines[1][i]=='R'
    end

    nodes = Dict{Int, Tuple{Int, Int}}()
    indexing_function = Dict{String, Int}()
    starting_nodes = Array{Int}(undef, length(lines))
    finishing_nodes = BitSet()
    num_starting_nodes = 0
    
    for (i, line) in enumerate(@view lines[3:end])
        key = @view line[1:3]
        indexing_function[key] = i
        if is_starting_node(key)
            num_starting_nodes += 1
            starting_nodes[num_starting_nodes] = i
        elseif is_finishing_node(key)
            push!(finishing_nodes, i)
        end
    end

    for line in view(lines, 3:lastindex(lines))
        key = indexing_function[@view line[1:3]]
        nodes[key] = (indexing_function[@view line[8:10]], indexing_function[@view line[13:15]])
    end
    return moves, nodes, view(starting_nodes, 1:num_starting_nodes), finishing_nodes
end

# Part 1

let lines = readlines("input")
    moves, nodes, starting_nodes, finishing_nodes = parse_input(lines, ==("AAA"), ==("ZZZ"))
    starting_node = first(starting_nodes)
    finishing_node = pop!(finishing_nodes)
    
    steps = 0
    current = starting_node
    current_move = 1
    
    while current != finishing_node
        ind = 1 + moves[current_move]
        current = nodes[current][ind]
        current_move = (current_move % length(moves)) + 1
        steps += 1
    end
    
    display(steps)
end

# Part 2

let lines = readlines("input")
    moves, nodes, starting_nodes, finishing_nodes = parse_input(lines, key-> last(key)==('A'), key->last(key)==('Z'))
    
    steps = 0
    steps_to_reach_finishing_node = zeros(Int, length(starting_nodes))
    current_move = 1
    current_nodes = copy(starting_nodes)
    
    while any(==(0), steps_to_reach_finishing_node)
        ind = 1 + moves[current_move]
        steps += 1
        current_move = (current_move % length(moves)) + 1

        for (i, node) in enumerate(current_nodes)
            if steps_to_reach_finishing_node[i] != 0
                continue
            end
            current_nodes[i] = nodes[node][ind]
            if (current_nodes[i] in finishing_nodes)
                steps_to_reach_finishing_node[i] = steps
            end
        end
    end
    
    display(lcm(steps_to_reach_finishing_node))
end