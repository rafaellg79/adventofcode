using SparseArrays

function read_bricks(lines)
    bricks = Array{NTuple{3, Int}}(undef, length(lines), 2)
    grid = zeros(Int, 10, 10, 400)
    for (i, line) in enumerate(lines)
        separator = findfirst(==('~'), line)
        p1 = Tuple(parse(Int, p)+d for (p, d) in zip(eachsplit((@view line[1:separator-1]), ','), (1, 1, 0)))
        p2 = Tuple(parse(Int, p)+d for (p, d) in zip(eachsplit((@view line[separator+1:end]), ','), (1, 1, 0)))
        bricks[i, 1] = p1
        bricks[i, 2] = p2
        grid[p1[1]:p2[1], p1[2]:p2[2], p1[3]:p2[3]] .= i
    end
    return bricks, grid
end

function can_move_down(grid, brick, brick_id)
    if brick[1][3] == 1
        return false
    end
    return all(x -> iszero(x) || x == brick_id, (@view grid[brick[1][1]:brick[2][1], brick[1][2]:brick[2][2], brick[1][3]-1]))
end

function fall!(bricks, grid)
    moved = true
    while moved
        moved = false
        for (i, brick) in enumerate(eachrow(bricks))
            if can_move_down(grid, brick, i)
                z1 = brick[1][3]
                z2 = brick[2][3]
                for x in brick[1][1]:brick[2][1], y in brick[1][2]:brick[2][2]
                    grid[x, y, z2] = 0
                    grid[x, y, z1-1] = i
                end
                bricks[i, 1] = brick[1] .- (0, 0, 1)
                bricks[i, 2] = brick[2] .- (0, 0, 1)
                moved = true
            end
        end
    end
end

function build_dependency_graph(bricks, grid)
    adjacency_matrix = spzeros(Bool, size(bricks, 1), size(bricks, 1))
    for (i, brick) in enumerate(eachrow(bricks))
        for cell in (@view grid[brick[1][1]:brick[2][1], brick[1][2]:brick[2][2], brick[2][3]+1])
            if !iszero(cell)
                adjacency_matrix[i, cell] = true
            end
        end
    end

    return adjacency_matrix
end

# Part 1

function safe_desintegration(adjacency_matrix)
    safe = trues(size(adjacency_matrix, 1))
    for j in eachcol(adjacency_matrix)
        if nnz(j) == 1
            safe[findfirst(!iszero, j)] = false
        end
    end
    return safe
end

let lines = readlines("input")
    bricks, grid = read_bricks(lines)
    
    fall!(bricks, grid)
    g = build_dependency_graph(bricks, grid)
    display(count(safe_desintegration(g)))
end

# Part 2

function nz_rows_from_col(S::SparseArrays.AbstractSparseMatrixCSC, col)
    return @view S.rowval[S.colptr[col]:(S.colptr[col+1]-1)]
end

let lines = readlines("input")
    bricks, grid = read_bricks(lines)
    
    fall!(bricks, grid)

    g = build_dependency_graph(bricks, grid)
    h = permutedims(g)

    score = 0
    falling = BitSet()
    next = Vector{Int}(undef, 10000)
    for i in 1:size(g, 1)
        empty!(falling)
        push!(falling, i)
        above_bricks = nz_rows_from_col(h, i)
        start = 1
        finish = length(above_bricks)
        next[start:finish] .= above_bricks
        while finish >= start
            v = next[start]
            start += 1
            if v in falling
                continue
            end
            below_bricks = nz_rows_from_col(g, v)
            if issubset(below_bricks, falling)
                push!(falling, v)
                above_bricks = nz_rows_from_col(h, v)
                next[finish+1:finish+length(above_bricks)] .= above_bricks
                finish += length(above_bricks)
            end
        end
        score += length(falling)-1
    end
    display(score)
end