const dir_map = Dict('L' => CartesianIndex(-1, 0), 'R' => CartesianIndex(1, 0), 'U' => CartesianIndex(0, -1), 'D' => CartesianIndex(0, 1))
const dir_array = [CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(-1, 0), CartesianIndex(0, -1)]

function find_area(vertices)
    sum_of_edges_area = transpose(@view vertices[1:end-1, :]) * (@view vertices[2:end, :])
    return sum_of_edges_area[1, 2] - sum_of_edges_area[2, 1]
end

# Part 1

let lines = readlines("input")
    vertices = zeros(Int, length(lines), 2)
    current = CartesianIndex(0, 0)
    perimeter = 0
    for (i, line) in enumerate(lines)
        dir = dir_map[line[1]]
        steps = 0
        for j in 3:(length(line)-10)
            steps = steps*10 + line[j] - '0'
        end
        
        perimeter += steps
        current += steps * dir
        vertices[i, :] .= current.I
    end
    
    display(div(find_area(vertices)+perimeter, 2)+1)
end

# Part 2

let lines = readlines("input")
    vertices = zeros(Int, length(lines), 2)
    current = CartesianIndex(0, 0)
    perimeter = 0
    for (i, line) in enumerate(lines)
        dir = dir_array[line[end-1]-'0'+1]
        steps = parse(Int, (@view line[end-6:end-2]); base=16)
        
        perimeter += steps
        current += steps * dir
        vertices[i, :] .= current.I
    end
    
    display(div(find_area(vertices)+perimeter, 2)+1)
end