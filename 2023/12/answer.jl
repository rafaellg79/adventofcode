# Verify if a springs row of KNOWN conditions is valid
function is_valid(springs, conditions; current=1)
    next = current
    if length(conditions) > 0 && conditions[1] == 0
        if springs[current] == '#'
            return false
        else
            current += 1
            conditions = @view conditions[2:end]
        end
    end
    for condition in conditions
        current = findnext(==('#'), springs, current)
        if isnothing(current)
            return false
        end
        next = findnext(!=('#'), springs, current)
        if isnothing(next)
            next = length(springs)+1
        end
        if condition != next-current
            return false
        end
        current = next
    end
    return isnothing(findnext(==('#'), springs, current))
end

function find_arrangements(springs, conditions; sols=Dict{Tuple{String, Vector{Int}}, Int}(), current=(1, 1))
    if springs[current[1]] == '.' && current[1]>1 && springs[current[1]-1] == '#' && conditions[current[2]] != 0
        return 0
    end
    if all(!=('?'), (@view springs[current[1]:end])) || current[2] > length(conditions)
        key = (join(@view springs[current[1]:end]), conditions[current[2]:end])
        if haskey(sols, key)
            return sols[key]
        end
        sols[key] = is_valid(springs, key[2]; current=current[1])
        return sols[key]
    end
    
    if springs[current[1]] == '?'
        key = (join(@view springs[current[1]:end]), conditions[current[2]:end])
        if haskey(sols, key)
            return sols[key]
        end
        springs[current[1]] = '#'
        arrangements = find_arrangements(springs, conditions; sols=sols, current=current)
        springs[current[1]] = '.'
        arrangements += find_arrangements(springs, conditions; sols=sols, current=current)
        springs[current[1]] = '?'
        sols[key] = arrangements
    elseif springs[current[1]] == '#'
        if conditions[current[2]] == 0
            return 0
        end

        conditions[current[2]] -= 1
        next = (current[1]+1, current[2])
        arrangements = find_arrangements(springs, conditions; sols=sols, current=next)
        conditions[current[2]] += 1
    elseif springs[current[1]] == '.'
        next = (current[1]+1, current[2] + (conditions[current[2]] == 0))
        arrangements = find_arrangements(springs, conditions; sols=sols, current=next)
    end
    
    return arrangements
end

# Part 1

let lines = readlines("input")
    arrangements = 0
    sols = Dict{Tuple{String, Vector{Int}}, Int}()
    
    for row in lines
        springs, conditions = split(row)
        conditions = parse.(Int, split(conditions, ','))
        arrangements += find_arrangements(collect(springs), conditions; sols=sols)
        empty!(sols)
    end
    
    display(arrangements)
end

# Part 2

let lines = readlines("input")
    arrangements = 0
    sols = Dict{Tuple{String, Vector{Int}}, Int}()
    
    for row in lines
        springs, conditions = split(row)
        springs = (springs * "?") ^ 4 * springs
        conditions = repeat(parse.(Int, split(conditions, ',')), 5)
        arrangements += find_arrangements(collect(springs), conditions; sols=sols)
        empty!(sols)
    end
    
    display(arrangements)
end