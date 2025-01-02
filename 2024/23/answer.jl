# Part 1

function add_edge!(G, u, v)
    if haskey(G, u)
        push!(G[u], v)
    else
        G[u] = [v]
    end
    if haskey(G, v)
        push!(G[v], u)
    else
        G[v] = [u]
    end
end

let lines = readlines("input")
    G = Dict{String, Vector{String}}()
    for line in lines
        u, v = split(line, '-')
        add_edge!(G, u, v)
    end
    
    components = Set()
    
    for u in keys(G)
        for v in G[u]
            for n in G[v]
                if n in G[u]
                    push!(components, Set([u, v, n]))
                end
            end
        end
    end
    
    s = 0
    for c in components
        for i in c
            if i[1] == 't'
                s+=1
                break
            end
        end
    end
    
    display(s)
end

# Part 2

const sols = Dict{Tuple{BitSet, Vector{Int}}, BitSet}()

function max_subset(G, set, neighborhood)
    if isempty(neighborhood)
        return copy(set)
    end
    if haskey(sols, (set, neighborhood))
        return sols[(set, neighborhood)]
    end
    max_s = BitSet()
    for n in neighborhood
        push!(set, n)
        temp = max_subset(G, set, intersect(neighborhood, G[n]))
        if length(temp) > length(max_s)
            max_s = temp
        end
        pop!(set, n)
    end
    sols[(set, neighborhood)] = max_s
    return max_s
end

function BronKerbosch(G, R, P, X)
    if isempty(P) && isempty(X)
        return R
    end
    sol = R
    for v in P
        temp = BronKerbosch(G, union(R, v), intersect(P, G[v]), intersect(X, G[v]))
        if length(temp) > length(sol)
            sol = temp
        end
        pop!(P, v)
        push!(X, v)
    end
    return sol
end

let lines = readlines("input")
    vertices_in_G = Set()
    vertices_ind = Dict{String, Int}()
    vertices_name = Dict{Int, String}()
    G = Dict{Int, Vector{Int}}()
    for line in lines
        u, v = split(line, '-')
        if !(u in vertices_in_G)
            push!(vertices_in_G, u)
            vertices_ind[u] = length(vertices_in_G)
            vertices_name[length(vertices_in_G)] = u
        end
        if !(v in vertices_in_G)
            push!(vertices_in_G, v)
            vertices_ind[v] = length(vertices_in_G)
            vertices_name[length(vertices_in_G)] = v
        end
        add_edge!(G, vertices_ind[u], vertices_ind[v])
    end
    
    max_set = BitSet()
    visited = BitSet()
    
    for v in keys(G)
        temp = max_subset(G, BitSet([v]), setdiff(G[v], visited))
        max_set = (length(max_set) < length(temp)) ? temp : max_set
        push!(visited, v)
    end
    #max_set = BronKerbosch(G, Set(), Set(keys(G)), Set())
    name = join(sort(map(x->vertices_name[x], collect(max_set))), ',')
    display(name)
end