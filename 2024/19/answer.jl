# Part 1

function is_possible(design, towels)
    possible = false
    for towel in towels
        if design == towel
            return true
        elseif startswith(design, towel) && is_possible(design[length(towel)+1:end], towels)
            return true
        end
    end
    return false
end

let lines = readlines("input")
    towels = strip.(split(lines[1], ','))
    designs = lines[3:end]
    
    c = 0
    
    for design in designs
        c += is_possible(design, towels)
    end
    
    display(c)
    
end

# Part 2

const sols = Dict{String, Int}()

function possible_ways(design, towels)
    if haskey(sols, design)
        return sols[design]
    end
    c = 0
    for towel in towels
        if design == towel
            c += 1
        elseif startswith(design, towel)
            c += possible_ways(design[length(towel)+1:end], towels)
        end
    end
    sols[design] = c
    return c
end

let lines = readlines("input")
    towels = strip.(split(lines[1], ','))
    designs = lines[3:end]
    
    c = 0
    
    for design in designs
        c += possible_ways(design, towels)
    end
    
    display(c)
    
end