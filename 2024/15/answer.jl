const dir_map = Dict('^' => CartesianIndex(-1, 0), 'v' => CartesianIndex(1, 0), '<' => CartesianIndex(0, -1), '>' => CartesianIndex(0, 1))

# Part 1

let lines = readlines("input")
    divisor = findfirst(isempty, lines)
    storage = permutedims(hcat(collect.(lines[1:divisor-1])...))
    instructions = join(lines[divisor:end])
    robot = findfirst(==('@'), storage)
    for instruction in instructions
        dir = dir_map[instruction]
        forward = robot + dir
        while storage[forward] != '#' && storage[forward] != '.'
            forward += dir
        end
        if storage[forward] == '#'
            continue
        end
        storage[robot] = '.'
        storage[forward] = 'O'
        robot = robot + dir
        storage[robot] = '@'
    end
    
    S = 0
    for I in CartesianIndices(storage)
        if storage[I] == 'O'
            S += (I[1]-1) * 100 + I[2]-1
        end
    end
    display(S)
end

# Part 2

let lines = readlines("input")
    divisor = findfirst(isempty, lines)
    storage_small = permutedims(hcat(collect.(lines[1:divisor-1])...))
    instructions = join(lines[divisor:end])
    
    storage = fill('.', size(storage_small, 1), size(storage_small, 2)*2)
    for I in CartesianIndices(storage_small)
        J = CartesianIndex(I[1], 2I[2]-1)
        if storage_small[I] == 'O'
            storage[J] = '['
            storage[J+CartesianIndex(0, 1)] = ']'
        end
        if storage_small[I] == '#'
            storage[J] = '#'
            storage[J+CartesianIndex(0, 1)] = '#'
        end
        if storage_small[I] == '@'
            storage[J] = '@'
        end
    end
    
    robot = findfirst(==('@'), storage)
    
    for instruction in instructions
        dir = dir_map[instruction]
        valid = true
        boxes = [robot]
        visited = Set{CartesianIndex{2}}()
        i = 0
        while i < length(boxes)
            i+=1
            push!(visited, boxes[i])
            forward = boxes[i] + dir
            if forward in visited
                continue
            elseif storage[forward] == '#' 
                valid = false
                break
            elseif storage[forward] == '.'
                continue
            elseif storage[forward] == '['
                if dir == CartesianIndex(0, -1)
                    push!(boxes, forward + CartesianIndex(0, 1), forward)
                else
                    push!(boxes, forward, forward + CartesianIndex(0, 1))
                end
            elseif storage[forward] == ']'
                if dir == CartesianIndex(0, 1)
                    push!(boxes, forward - CartesianIndex(0, 1), forward)
                else
                    push!(boxes, forward, forward - CartesianIndex(0, 1))
                end
            end
        end
        if !valid
            continue
        end
        empty!(visited)
        for i in length(boxes):-1:1
            box = boxes[i]
            if box in visited
                continue
            else
                push!(visited, box)
            end
            storage[box + dir] = storage[box]
            storage[box] = '.'
        end
        robot = robot+dir
    end
    
    S = 0
    for I in CartesianIndices(storage)
        if storage[I] == '['
            S += (I[1]-1) * 100 + I[2] - 1
        end
    end
    display(S)
end
