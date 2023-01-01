using Scanf, Graphs

let input = readlines("input")
    G = SimpleDiGraph()
    valves_id = Dict{String, Int}()
    valves_flow_rate = zeros(Int, length(input))
    for line in input
        n, valve, flow, tunnels = @scanf line "Valve %s has flow rate=%i; tunnels lead to valves %[^\n]" String Int String
        if n == 2
            _, valve, flow, tunnels = @scanf line "Valve %s has flow rate=%i; tunnel leads to valve %s" String Int String
        end
        tunnels = split(strip(tunnels), ", ")
        
        valve_id = get(valves_id, valve, nv(G) + 1)
        if !haskey(valves_id, valve)
            valves_id[valve] = valve_id
            add_vertex!(G)
        end
        
        valves_flow_rate[valve_id] = flow
        
        for neighbor in tunnels
            neighbor_id = get(valves_id, neighbor, nv(G) + 1)
            if !haskey(valves_id, neighbor)
                valves_id[neighbor] = neighbor_id
                add_vertex!(G)
            end
            add_edge!(G, valve_id, neighbor_id)
        end
    end
    
    start = valves_id["AA"]
    
    struct TraversalState
        current_nodes::Vector{Int}
        closed_valves::Set{Int}
        released_pressure::Int
        minutes::Vector{Int}
    end
    
    function traverse(G::SimpleDiGraph, src::Vector{Int}, node_weights::Vector{Int}, limit::Int)
        shortest_distances = floyd_warshall_shortest_paths(G).dists
        positive_weights = sort(findall(!=(0), node_weights); lt=(a, b) -> node_weights[a]>=node_weights[b])
        next = TraversalState[TraversalState(src, Set{Int}(positive_weights), 0, zeros(Int, length(src)))]
        max_path = 0
        while !isempty(next)
            state = pop!(next)
            
            if first(state.minutes) < limit
                visited_node = state.current_nodes[1]
                current_time = state.minutes[1]
                if node_weights[visited_node] > 0 && (visited_node in state.closed_valves)
                    current_time += 1
                    state = TraversalState(state.current_nodes, setdiff(state.closed_valves, visited_node), state.released_pressure+node_weights[visited_node]*(limit-current_time), [current_time, state.minutes[2:end]...])
                    max_path = max(max_path, state.released_pressure)
                    if isempty(state.closed_valves)
                        max_path = max(max_path, state.released_pressure + sum(node_weights[state.current_nodes[2:end]].*((limit-1).-state.minutes[2:end])))
                    end
                end
                
                max_remaining = sum((n) -> node_weights[n]*(limit-(current_time+minimum(shortest_distances[state.current_nodes, n]))), state.closed_valves; init=0)
                
                if max_path >= max_remaining + state.released_pressure
                    continue
                end
                
                for v in state.closed_valves
                    dist = shortest_distances[visited_node, v]
                    minutes = copy(state.minutes)
                    nodes = copy(state.current_nodes)
                    minutes[1] += dist
                    nodes[1] = v
                    p = sortperm(minutes)
                    push!(next, TraversalState(nodes[p], copy(state.closed_valves), state.released_pressure, minutes[p]))
                end
            end
        end
        return max_path
    end
    
    # Part 1
    display(traverse(G, [start], valves_flow_rate, 30))
    
    # Part 2
    display(traverse(G, [start; start], valves_flow_rate, 26))
end