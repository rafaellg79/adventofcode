using SparseArrays

const dir = CartesianIndex[CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(0, -1), CartesianIndex(-1, 0)]
const char_dir = Char['v', '>', '<', '^']
const map_dir = Dict(char_dir .=> dir)

function dfs(dists, seed, target)
    next = Tuple{Int, Int, Int}[(-1, seed, 0)]
    visited = falses(size(dists))
    path = Array{Int}(undef, 1000)
    path[1] = -1
    path_len = 1
    maxdist = 0
    while !isempty(next)
        (ancestor, current, dist) = pop!(next)
        if current == target
            maxdist = max(dist, maxdist)
        end
        while path[path_len] != ancestor
            visited[path[path_len]] = false
            path_len -= 1
        end
        path_len += 1
        path[path_len] = current
        visited[path[path_len]] = true
        
        for ind in dists.colptr[current]:(dists.colptr[current+1]-1)
            neighbor = dists.rowval[ind]
            d = dists.nzval[ind]
            if !visited[neighbor]
                push!(next, (current, neighbor, dist+d))
            end
        end
    end
    return maxdist
end

function find_forks(matrix)
    return findall(CartesianIndices(matrix)) do I
        num_neighbors = 0
        if matrix[I] == '#'
            return false
        end
        for d in dir
            if checkbounds(Bool, matrix, I+d) && (matrix[I+d] != '#')
                num_neighbors += 1
            end
        end
        return num_neighbors > 2
    end
end

function find_dists(matrix, vertices)
    dists = spzeros(Int, length(vertices), length(vertices))
    for (i, v) in enumerate(vertices)
        neighbors = dir
        if (matrix[v] in keys(map_dir))
            neighbors = [map_dir[matrix[current]]]
        end
        for n in neighbors
            dist = 1
            previous = v
            u = v + n
            w = u
            if !checkbounds(Bool, matrix, u)
                continue
            end
            while !(u in vertices)
                if haskey(map_dir, matrix[u])
                    w = u + map_dir[matrix[u]]
                    if w == previous
                        break
                    end
                end
                for d in dir
                    w = u + d
                    if checkbounds(Bool, matrix, w) && matrix[w] != '#' && w != previous
                        previous = u
                        u = w
                        dist += 1
                        break
                    end
                end
                if u != w
                    break
                end
            end
            j = findfirst(==(u), vertices)
            if !isnothing(j)
                dists[j, i] = max(dist, dists[j, i])
            end
        end
    end
    return dists
end

function build_graph(matrix, seed, target)
    vertices = find_forks(matrix)
    push!(vertices, seed, target)

    edges = find_dists(matrix, vertices)

    return vertices, edges
end

# Part 1

let lines = readlines("input")
    matrix = reduce(vcat, permutedims.(collect.(lines)))
    V, E = build_graph(matrix, CartesianIndex(1, 2), CartesianIndex(size(matrix, 1), size(matrix, 2)-1))
    display(dfs(E, lastindex(V) - 1, lastindex(V)))
end

# Part 2

let lines = readlines("input")
    matrix = reduce(vcat, permutedims.(collect.(lines)))
    replace!(matrix, '>' => '.', 'v' => '.', '^' => '.', '<' => '.')
    V, E = build_graph(matrix, CartesianIndex(1, 2), CartesianIndex(size(matrix, 1), size(matrix, 2)-1))
    display(dfs(E, lastindex(V) - 1, lastindex(V)))
end