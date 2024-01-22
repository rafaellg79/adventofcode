function get_indexing_function(lines)
    indexing_function = Dict{String, Int}()
    
    for line in lines
        source_module, destination_modules = split(line, " -> ")
        if source_module[1] == '%' || source_module[1] == '&'
            if !haskey(indexing_function, source_module[2:end])
                indexing_function[source_module[2:end]] = length(indexing_function)+1
            end
        elseif !haskey(indexing_function, source_module)
            indexing_function[source_module] = length(indexing_function)+1
        end
        for module_name in split(destination_modules, ", ")
            if !haskey(indexing_function, module_name)
                indexing_function[module_name] = length(indexing_function)+1
            end
        end
    end
    return indexing_function
end

function propagate_signal!(signals, adjacency_list, reverse_adjacency_list, state, conjunction_modules, flip_flops)
    signal, src_module = popfirst!(signals)
    dst_modules = adjacency_list[src_module]
    lo, hi = 0, 0
    if src_module in conjunction_modules
        state[src_module] = ~all(==(true), values(reverse_adjacency_list[src_module]))
    elseif (src_module in flip_flops)
        if (signal == false)
            state[src_module] = ~state[src_module]
        else
            if signal == 1
                hi += 1
            else
                lo += 1
            end
            return lo, hi
        end
    end
    for d in dst_modules
        if d in conjunction_modules
            reverse_adjacency_list[d][src_module] = state[src_module]
        end
    end
    append!(signals, map((x) -> (state[src_module], x), adjacency_list[src_module]))
    
    if signal == 1
        hi += 1
    else
        lo += 1
    end
    
    return lo, hi
end

# Part 1

let lines = readlines("input")
    indexing_function = get_indexing_function(lines)
    adjacency_list = Array{Vector}(undef, length(indexing_function))
    reverse_adjacency_list = Dict{Int, Bool}[Dict{Int, Bool}() for _ in 1:length(indexing_function)]
    conjunction_modules = Set()
    flip_flops = Set()
    
    for i in eachindex(adjacency_list)
        adjacency_list[i] = []
    end
    
    for line in lines
        source_module, destination_modules = split(line, " -> ")
        if source_module[1] == '&'
            source_module = source_module[2:end]
            source_module = indexing_function[source_module]
            push!(conjunction_modules, source_module)
        elseif source_module[1] == '%'
            source_module = source_module[2:end]
            source_module = indexing_function[source_module]
            push!(flip_flops, source_module)
        else
            source_module = indexing_function[source_module]
        end
        
        adjacency_list[source_module] = map(x -> indexing_function[x], split(destination_modules, ", "))
        for d in split(destination_modules, ", ")
            reverse_adjacency_list[indexing_function[d]][source_module] = false
        end
    end
            
    
    state = falses(length(adjacency_list))
    lo = 0
    hi = 0
    
    for i = 1:1000
        signals = Tuple{Int, Int}[(0, indexing_function["broadcaster"])]
        while !isempty(signals)
            lohi = propagate_signal!(signals, adjacency_list, reverse_adjacency_list, state, conjunction_modules, flip_flops)
            lo += lohi[1]
            hi += lohi[2]
        end
    end
    
    display(lo * hi)
end

# Part 2

let lines = readlines("input")
    indexing_function = get_indexing_function(lines)
    
    adjacency_list = Array{Vector{Int}}(undef, length(indexing_function))
    reverse_adjacency_list = Dict{Int, Bool}[Dict{Int, Bool}() for _ in 1:length(indexing_function)]
    conjunction_modules = Set()
    flip_flops = Set()
    
    for i in eachindex(adjacency_list)
        adjacency_list[i] = Int[]
    end
    
    for line in lines
        source_module, destination_modules = split(line, " -> ")
        if source_module[1] == '&'
            source_module = source_module[2:end]
            source_module = indexing_function[source_module]
            push!(conjunction_modules, source_module)
        elseif source_module[1] == '%'
            source_module = source_module[2:end]
            source_module = indexing_function[source_module]
            push!(flip_flops, source_module)
        else
            source_module = indexing_function[source_module]
        end
        
        adjacency_list[source_module] = map(x -> indexing_function[x], split(destination_modules, ", "))
        for d in split(destination_modules, ", ")
            reverse_adjacency_list[indexing_function[d]][source_module] = false
        end
    end
    
    state = falses(length(adjacency_list))
    last_state = copy(state)
    lo = 0
    hi = 0
    
    cycles = zeros(Int, length(adjacency_list))

    conjunction_module_to_reset = first(keys(reverse_adjacency_list[indexing_function["rx"]]))
    input_modules = collect(keys(reverse_adjacency_list[conjunction_module_to_reset]))
    input_modules = collect(map(key -> first(keys(reverse_adjacency_list[key])), input_modules))
    button_presses_to_activate = zeros(Int, length(input_modules))
    
    for i = 1:100000

        if all(!iszero, button_presses_to_activate)
            break
        end

        signals = [(0, indexing_function["broadcaster"])]
        if i > 1
            for n in eachindex(state)
                if state[n] != last_state[n] && cycles[n] == 0
                    cycles[n] = i
                end
            end
        end
        last_state .= state
        while !isempty(signals)
            if i > 1
                for (j, mod) in enumerate(input_modules)
                    if iszero(state[mod])
                        button_presses_to_activate[j] = i
                    end
                end
            end
            lohi = propagate_signal!(signals, adjacency_list, reverse_adjacency_list, state, conjunction_modules, flip_flops)
            lo += lohi[1]
            hi += lohi[2]
        end
    end
    display(lcm(button_presses_to_activate...))
end