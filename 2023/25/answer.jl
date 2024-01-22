using SparseArrays

# Based on wikipedia's article on Stoer-Wagner algorithm (https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm#Example_code)

function mincut!(adjacency_matrix; min_weight=3)
    best = (typemax(Int), BitSet())
    N = size(adjacency_matrix, 1)
    co = BitSet[BitSet(i) for i = 1:N]
    w = Array{Int}(undef, size(adjacency_matrix, 2))
    active_nodes = BitSet(1:N)
    
    for ph = 2:N
        for i = 1:N
            w[i] = adjacency_matrix[1, i]
        end
        s = 1
        t = 1
        for it = ph:N
            w[t] = typemin(Int)
            s = t
            t = 2
            for i = 3:N
                if w[t] < w[i]
                    t = i
                end
            end
            if w[t] - adjacency_matrix[t, t] > min_weight
                break
            end
            for i in active_nodes
                w[i] += adjacency_matrix[t, i]
            end
        end
        delete!(active_nodes, t)
        if w[t] - adjacency_matrix[t, t] < best[1]
            best = (w[t] - adjacency_matrix[t, t], co[t])
            if best[1] == min_weight
                return best
            end
        end
        union!(co[s], co[t])
        for i in active_nodes
            adjacency_matrix[s, i] += adjacency_matrix[t, i]
            adjacency_matrix[i, s] = adjacency_matrix[s, i]
        end
        adjacency_matrix[1, t] = typemin(Int)
    end
    return best
end

# Part 1

let lines = readlines("input")
    components = spzeros(Bool, 10000, 10000)
    indexing_function = Dict{String, Int}()
    for line in lines
        component, connected = split(line, ':')
        connected = split(connected)

        if !haskey(indexing_function, component)
            indexing_function[component] = length(indexing_function)+1
        end
        for c in connected
            if !haskey(indexing_function, c)
                indexing_function[c] = length(indexing_function)+1
            end
            components[indexing_function[component], indexing_function[c]] = true
        end
    end
    
    diagram = zeros(Int, length(indexing_function), length(indexing_function))
    for u in 1:(length(components.colptr)-1)
        for v in components.rowval[components.colptr[u]:(components.colptr[u+1]-1)]
            diagram[u, v] = 1
            diagram[v, u] = 1
        end
    end

    w, partition = mincut!(diagram)
    @assert w == 3 "Wrong cut."
    C1 = length(partition)
    C2 = size(diagram, 1) - C1
    display(C1 * C2)
end