const dir = [CartesianIndex(-1,0), CartesianIndex(1,0), CartesianIndex(0, -1), CartesianIndex(0, 1)]

function encode(x::CartesianIndex{2})
    return UInt16(x[1]<<8 | x[2])
end

function decode(x)
    return CartesianIndex((x>>8) & 0xff, x & 0xff)
end

# Not really a dfs because there is no guaranteed order in Set
function dfs(seed, steps, matrix)
    current = BitSet()
    next = BitSet(encode(seed))
    even = 1
    odd = 0
    visited = falses(size(matrix))
    for step = 1:steps
        current, next = next, current
        for encoded_pos in current
            pos = decode(encoded_pos)
            visited[pos] = true
            for d in dir
                if checkbounds(Bool, matrix, pos+d) && !matrix[pos+d]
                    if visited[pos+d]
                        delete!(next, encode(pos+d))
                    elseif !(encode(pos+d) in next)
                        if iseven(step)
                            even += 1
                        else
                            odd += 1
                        end
                        push!(next, encode(pos+d))
                    end
                end
            end
        end
    end
    return iseven(steps) ? even : odd
end

# Part 1

let lines = readlines("input")
    matrix = reduce(vcat, permutedims.(collect.(lines)))
    starting_pos = findfirst(==('S'), matrix)
    matrix = BitArray(c == '#' for c in matrix)
    
    display(dfs(starting_pos, 64, matrix))
end

# Part 2

let lines = readlines("input")
    matrix = reduce(vcat, permutedims.(collect.(lines)))
    total_steps = 26501365
    
    center = findfirst(==('S'), matrix)
    matrix = BitArray(c == '#' for c in matrix)
    dist_matrix = map(c -> c ? -1 : 0, matrix)
    
    next = BitSet(encode(center))
    while !isempty(next)
        pos = decode(pop!(next))
        for d in dir
            if checkbounds(Bool, matrix, pos+d) && !matrix[pos+d]
                if dist_matrix[pos+d] == 0
                    push!(next, encode(pos+d))
                    dist_matrix[pos+d] = dist_matrix[pos] + 1
                end
            end
        end
    end

    # I'm kinda ashamed of this solution...
    # The first thing I noticed from the puzzle is that it was possible to divide the grid into even and odd positions that would alternate between each step.
    # The border of the example being cleared out of obstacles made me realize that there would likely be a pattern that would repeat in each section.
    # So just compute the number of visited cells in half filled and fully filled sections and calculate the number of each sections.
    # However, computing the half filled sections is a rather complicated task.
    # Given an arbitrary grid with obstacles in any position, the half filled sections could be filled in any way.
    # They could even vary from section to section.
    # After a day thinking about the puzzle I gave up and looked in reddit to realize the input data, different from the example data, had a column and row free of obstacles at the center where the starting point is located!
    # That and the cleared borders are probably enough to guarantee that the half filled sections would all be equally filled.
    # Then I saw a solution based on counting the number of cells visited from a starting point and decided to implement that to finish this puzzle already (the only puzzle I needed more than 24h to solve).
    # Thus the credits for this answer should go to reddit user YellowZoro.
    
    h, w = size(matrix)
    E = count(iseven, filter(>(0), dist_matrix))
    O = count(isodd, filter(>(0), dist_matrix))
    N = div(total_steps, size(matrix, 1))
    steps = div(3h-3, 2)
    A = dfs(CartesianIndex(1, 1), steps, matrix) + dfs(CartesianIndex(1, w), steps, matrix) + dfs(CartesianIndex(h, 1), steps, matrix) + dfs(CartesianIndex(h, w), steps, matrix)
    steps = div(h-3, 2)
    B = dfs(CartesianIndex(1, 1), steps, matrix) + dfs(CartesianIndex(1, w), steps, matrix) + dfs(CartesianIndex(h, 1), steps, matrix) + dfs(CartesianIndex(h, w), steps, matrix)
    steps = h-1
    T = dfs(CartesianIndex(1, center[2]), steps, matrix) + dfs(CartesianIndex(center[1], 1), steps, matrix) + dfs(CartesianIndex(h, center[2]), steps, matrix) + dfs(CartesianIndex(center[1], w), steps, matrix)
    display((N-1)^2 * O + N^2 * E + (N-1) * A + N * B + T)
end