function sum_shortest_paths(positions, rows_weight, cols_weight)
    rows_distance = cumsum(rows_weight)
    cols_distance = cumsum(cols_weight)
    total = 0
    for (i, u) in enumerate(positions)
        for v in (@view positions[i+1:end])
            x1, x2 = extrema((u[1], v[1]))
            y1, y2 = extrema((u[2], v[2]))
            total += rows_distance[x2]-rows_distance[x1] + cols_distance[y2]-cols_distance[y1]
        end
    end
    return total
end

# Part 1

let lines = readlines("input")
    matrix_of_characters = reduce(vcat, permutedims.(collect.(lines)))
    
    rows_weight = [all(==('.'), matrix_of_characters[i, :]) ? 2 : 1
                   for i = eachindex(@view matrix_of_characters[:, 1])]
    cols_weight = [all(==('.'), matrix_of_characters[:, i]) ? 2 : 1
                   for i = eachindex(@view matrix_of_characters[1, :])]
    
    galaxies = CartesianIndices(matrix_of_characters)[findall(==('#'), matrix_of_characters)]
    
    display(sum_shortest_paths(galaxies, rows_weight, cols_weight))
end

# Part 2

let lines = readlines("input")
    matrix_of_characters = reduce(vcat, permutedims.(collect.(lines)))
    
    rows_weight = [all(==('.'), matrix_of_characters[i, :]) ? 1000000 : 1
                   for i = eachindex(@view matrix_of_characters[:, 1])]
    cols_weight = [all(==('.'), matrix_of_characters[:, i]) ? 1000000 : 1
                   for i = eachindex(@view matrix_of_characters[1, :])]
    
    galaxies = CartesianIndices(matrix_of_characters)[findall(==('#'), matrix_of_characters)]
    
    display(sum_shortest_paths(galaxies, rows_weight, cols_weight))
end