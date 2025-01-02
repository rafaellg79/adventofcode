const dirs = (CartesianIndex(-1, 0), CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(0, 1))

function compute_dists(dists, start, finish)
    next = Set{CartesianIndex{2}}()
    push!(next, start)
    
    while !isempty(next)
        n = pop!(next)
        d = dists[n]
        for dir in dirs
            if d+1 < get(dists, n + dir, -1)
                dists[n+dir] = d+1
                push!(next, n+dir)
            end
        end
    end
end

function parse_bytes!(dists, lines, corrupted_bytes)
    pos = []
    for line in lines[1:corrupted_bytes]
        push!(pos, CartesianIndex(1, 1) + CartesianIndex((parse.(Int, split(line, ',')))...))
    end
    
    dists[1, 1] = 0
    
    for p in pos
        dists[p] = -1
    end
    return dists
end

# Part 1

let lines = readlines("input")
    
    start = CartesianIndex(1, 1)
    finish = start + CartesianIndex(70, 70)
    
    dists = fill(typemax(Int), finish.I)
    parse_bytes!(dists, lines, 1024)
    
    compute_dists(dists, start, finish)
    
    display(dists[finish])
end

# Part 2

let lines = readlines("input")
    left, right = 1, length(lines)
    
    start = CartesianIndex(1, 1)
    finish = start + CartesianIndex(70, 70)
    
    dists = fill(typemax(Int), finish.I)
    dists_original = copy(dists)
    
    while right - left > 1
        dists .= dists_original
        mid = div(left + right, 2)
        parse_bytes!(dists, lines, mid)
        
        compute_dists(dists, start, finish)
        
        if dists[finish] == typemax(Int)
            right = mid
        else
            left = mid
        end
    end
    
    display(CartesianIndex((parse.(Int, split(lines[right], ',')))...))
end