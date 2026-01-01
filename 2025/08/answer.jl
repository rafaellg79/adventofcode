function dist(u, v)
    return sum(x -> x^2, u .- v)
end

function dist(u::CartesianIndex, v::CartesianIndex)
    return dist(u.I, v.I)
end

# Part 1

let lines = readlines("input")
    boxes = []
    for line in lines
        push!(boxes, CartesianIndex(parse.(Int, split(line, ','))...))
    end
    
    dists = fill(typemax(Int), length(boxes), length(boxes))
    
    for i in 1:length(boxes), j in i+1:length(boxes)
        dists[i, j] = dist(boxes[i], boxes[j])
    end
    
    clusters = [Set(i) for i in 1:length(boxes)]
    
    for _ in 1:1000
        _, I = findmin(dists)
        dists[I] = typemax(Int)
        i, j = I.I
        set_i = findfirst(x-> i in x, clusters)
        set_j = findfirst(x-> j in x, clusters)
        if set_i != set_j
            union!(clusters[set_i], clusters[set_j])
            deleteat!(clusters, set_j)
        end
    end
    display(prod(sort(length.(clusters), rev=true)[1:3]))
end

# Part 2

let lines = readlines("input")
    boxes = []
    for line in lines
        push!(boxes, CartesianIndex(parse.(Int, split(line, ','))...))
    end
    
    dists = fill(typemax(Int), length(boxes), length(boxes))
    
    for i in 1:length(boxes), j in i+1:length(boxes)
        dists[i, j] = dist(boxes[i], boxes[j])
    end
    
    clusters = [Set(i) for i in 1:length(boxes)]
    last_pair = (0,0)
    
    while length(clusters) > 1
        _, I = findmin(dists)
        dists[I] = typemax(Int)
        i, j = I.I
        set_i = findfirst(x-> i in x, clusters)
        set_j = findfirst(x-> j in x, clusters)
        if set_i != set_j
            union!(clusters[set_i], clusters[set_j])
            deleteat!(clusters, set_j)
        end
        last_pair = (i, j)
    end
    display(boxes[last_pair[1]][1] * boxes[last_pair[2]][1])
end