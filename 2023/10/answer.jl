function dfs(matrix, start)
    queue = Array{Tuple{Int, Int}}(undef, length(matrix))
    dists = fill(typemax(Int), size(matrix))
    
    queue_len = 1
    queue[queue_len] = start
    dists[start[1], start[2]] = 0
    
    while queue_len > 0
        pos = queue[queue_len]
        queue_len -= 1
        d = dists[pos[1], pos[2]]
        pipe = matrix[pos[1], pos[2]]
        for i = 0:3
            s = 1 - 2*((i&1)==0)
            dst = CartesianIndex(pos .+ ((((i&2) == 0), (i&2 != 0)) .* s))
            if (pipe & (1 << i) != 0) && checkbounds(Bool, dists, dst) && d+1 < dists[dst]
                queue_len += 1
                queue[queue_len] = dst.I
                dists[dst] = d+1
            end
        end
    end
    return dists
end

# 1 - North
# 2 - South
# 4 - West
# 8 - East
const connection_map = Dict(
    '|' => 1 | 2,
    '-' => 4 | 8,
    'L' => 1 | 8,
    'J' => 1 | 4,
    '7' => 2 | 4,
    'F' => 2 | 8,
    '.' => 0,
    'S' => -1
)

# Part 1

let lines = readlines("input")
    score = 0
    
    matrix = Array{Int8}(undef, length(lines), length(lines[1]))
    
    start = 0
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            matrix[i, j] = connection_map[c]
            if c == 'S'
                start = (i, j)
                matrix[i, j] = 0
            end
        end
    end
    
    for n = 0:3
        s = 1 - 2*((n&1)==0)
        neighbor = CartesianIndex(start .+ ((((n&2) == 0), (n&2 != 0)) .* s))
        inv_n = xor(n, 1) # flips least significant bit
        matrix[start...] |= (((matrix[neighbor]) & (1 << inv_n)) != 0) << n
    end
    
    dists = dfs(matrix, start)
    display(maximum(x -> x==typemax(Int) ? 0 : x, dists))
end

# Part 2

function scanline(matrix)
    inside = 0
    for i = 1:size(matrix, 1)
        winding_number = 0
        for j = 1:size(matrix, 2)
            if iszero(matrix[i, j])
                inside += !iszero(winding_number)
            else
                winding_number = xor(winding_number, matrix[i, j] & (1 | 2))
            end
        end
    end
    return inside
end

let lines = readlines("input")
    score = 0
    
    matrix = Array{Int}(undef, length(lines), length(lines[1]))
    
    start = 0
    for (i, line) in enumerate(lines)
        for (j, c) in enumerate(line)
            matrix[i, j] = connection_map[c]
            if c == 'S'
                start = (i, j)
                matrix[i, j] = 0
            end
        end
    end
    
    for n = 0:3
        s = 1 - 2*((n&1)==0)
        neighbor = CartesianIndex(start .+ ((((n&2) == 0), (n&2 != 0)) .* s))
        inv_n = xor(n, 1) # flips least significant bit
        matrix[start...] |= (((matrix[neighbor]) & (1 << inv_n)) != 0) << n
    end
    
    dists = dfs(matrix, start)
    
    display(scanline(map!((pipe, dist) -> dist == typemax(Int) ? 0 : pipe, matrix, matrix, dists)))
end