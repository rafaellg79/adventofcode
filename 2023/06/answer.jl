function distance_traveled(hold_time, total_time)
    return hold_time * (total_time - hold_time)    
end

function binary_search(t, d)
    l = 0
    r = div(t, 2)
    m = div(l + r + 1, 2)
    while r - l > 1
        m = div(l + r + 1, 2)
        if m * (t - m) <= d
            l = m
        else
            r = m
        end
    end
    return l * (t-l) > d ? l : r
end

function possibilities_to_beat_record(t, d)
    left = binary_search(t, d)
    right = div(t+1, 2)
    right += (right-left) - isodd(t)
    return length(left:right)
end

# Part 1

let lines = readlines("input")
    times = lines[1][findfirst(isdigit, lines[1]):end]
    times = parse.(Int, filter(!isempty, split(times)))
    
    distances = lines[2][findfirst(isdigit, lines[2]):end]
    distances = parse.(Int, filter(!isempty, split(distances)))
    
    error_margin = map(possibilities_to_beat_record, times, distances)
    display(prod(error_margin))
end

# Part 2

let lines = readlines("input")
    time = lines[1][findfirst(isdigit, lines[1]):end]
    distance = lines[2][findfirst(isdigit, lines[2]):end]
    t = 0
    for digit in time
        if !isspace(digit)
            t = t * 10 + (digit - '0')
        end
    end
    d = 0
    for digit in distance
        if !isspace(digit)
            d = d * 10 + (digit - '0')
        end
    end
    display(possibilities_to_beat_record(t, d))
end