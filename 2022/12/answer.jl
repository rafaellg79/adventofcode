using Graphs

let input = readlines("input")
    A = hcat(collect.(input)...)
    B = LinearIndices(A)
    S = findfirst(==('S'), A)
    E = findfirst(==('E'), A)
    A[S] = 'a'
    A[E] = 'z'
    G = SimpleDiGraph(length(A))
    
    for I in CartesianIndices(B)
        for dir in [CartesianIndex(1, 0); CartesianIndex(0, 1);CartesianIndex(-1, 0); CartesianIndex(0, -1)]
            J = I+dir
            if checkbounds(Bool, A, J) && ((A[J] - A[I]) <= 1)
                add_edge!(G, B[I], B[J])
            end
        end
    end
    
    # Part 1
    parents = bfs_parents(G, B[E]; dir=in)
    current = B[S]
    dist = 0
    while current != B[E]
        current = parents[current]
        dist +=1
    end
    display(dist)
    
    # Part 2
    current = B[findall(==('a'), A)]
    filter!(v -> parents[v] > 0, current)
    dist = 0
    while all(!=(B[E]), current)
        map!(v -> parents[v], current, current)
        dist += 1
    end
    display(dist)
    
end