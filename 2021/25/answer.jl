cucumbers = permutedims(hcat(collect.(readlines("input"))...))

current = copy(cucumbers)
next = typeof(current)(undef, size(current))
buffer = typeof(current)(undef, size(current))

function move!(current, next, visited, i, j, next_ind, next_test)
    if visited[i, j]
        return
    end
    visited[i, j] = true
    k, l = next_ind(current, i, j)
    if next_test(current[i, j], current[k, l])
        next[i, j] = current[k, l]
        next[k, l] = current[i, j]
        visited[k, l] = true
    else
        next[i, j] = current[i, j]
    end
end

move_east!(current, next, visited, i, j) = move!(current, next, visited, i, j, (c, i, j) -> (i, j%size(c, 2)+1), (c, n) -> c=='>' && n == '.')
move_south!(current, next, visited, i, j) = move!(current, next, visited, i, j, (c, i, j) -> (i%size(c, 1)+1, j), (c, n) -> c=='v' && n == '.')

function step!(current, next, move; visited = falses(size(current)))
    for i in 1:size(current, 1)
        for j in 1:size(current, 2)
            move(current, next, visited, i, j)
        end
    end
    return next
end

function step!(current, next; buffer=typeof(current)(undef, size(current)), visited_buffer=falses(size(current)))
    visited_buffer .= false
    step!(current, buffer, move_east!; visited = visited_buffer)
    step!(buffer, next, move_south!; visited = (visited_buffer .= false))
end

let steps = 0, visited_buffer = falses(size(current))
    while current != next
        step!(current, next; buffer=buffer)
        steps += 1
        
        if current != next
            step!(next, current; buffer=buffer, visited_buffer)
            steps += 1
        end
    end

    display(steps)
end