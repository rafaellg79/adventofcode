function test_dir(matrix, I, dir)
    X = I
    M = I + dir
    A = I + 2dir
    S = I + 3dir
    if get(matrix, X, ' ') == 'X' && get(matrix, M, ' ') == 'M' && get(matrix, A, ' ') == 'A' && get(matrix, S, ' ') == 'S'
        return 1
    end
    return 0
end

function find_xmas(matrix, I)
    n = 0
    for i in -1:1, j in -1:1
        n += test_dir(matrix, I, CartesianIndex(i, j))
    end
    return n
end

# Part 1

let lines = readlines("input")
    matrix = Array{Char}(undef, length(lines), length(lines[1]))
    
    for i in 1:length(lines), j in 1:length(lines[i])
        matrix[i, j] = lines[i][j]
    end
    
    xmas = 0
    
    for I in CartesianIndices(matrix)
        xmas += find_xmas(matrix, I)
    end
    
    display(xmas)
end

# Part 2

function test_mas(matrix, I, dir)
    perp_dir = CartesianIndex(dir[2], -dir[1])
    M = get(matrix, I+dir, ' ')
    S = get(matrix, I-dir, ' ')
    if M != 'M'
        temp = M
        M = S
        S = temp
    end
    if matrix[I] == 'A' && M == 'M' && S == 'S' && get(matrix, I+dir, ' ') == get(matrix, I+perp_dir, '-') && get(matrix, I-dir, ' ') == get(matrix, I-perp_dir, '-')
        return 1
    end
    return 0
end

function find_x_mas(matrix, I)
    n = 0
    for i in (-1, 1), j in (-1,1)
        n += test_mas(matrix, I, CartesianIndex(i, j))
    end
    return n
end

let lines = readlines("input")
    matrix = Array{Char}(undef, length(lines), length(lines[1]))
    
    for i in 1:length(lines), j in 1:length(lines[i])
        matrix[i, j] = lines[i][j]
    end
    
    xmas = 0
    
    for I in CartesianIndices(matrix)[2:end-1, 2:end-1]
        xmas += find_x_mas(matrix, I)
    end
    
    display(div(xmas, 2))
end