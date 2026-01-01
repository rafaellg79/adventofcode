# Part 1

let lines = readlines("input")
    blank = 0
    for i = 1:length(lines)
        if lines[i] == ""
            blank = i
        end
    end
    
    ranges = map(x-> UnitRange(parse.(Int, split(x, '-'))...), lines[1:blank-1])
    available = parse.(Int, lines[blank+1:end])
    n = 0
    
    for m in available
        for r in ranges
            if m in r
                n+=1
                break
            end
        end
    end
    display(n)
end

# Part 2

function merge_ranges(r1, r2)
    if r1[1] <= r2[end] && r2[1] <= r1[end]
        return min(r1[1], r2[1]):max(r1[end], r2[end])
    end
    return 0:-1
end

let lines = readlines("input")
    blank = 0
    for i = 1:length(lines)
        if lines[i] == ""
            blank = i
        end
    end
    
    ranges = map(x-> UnitRange(parse.(Int, split(x, '-'))...), lines[1:blank-1])
    merged_ranges = Set{UnitRange}()
    for r in ranges
        if isempty(merged_ranges)
            push!(merged_ranges, r)
            continue
        end
        
        for m in copy(merged_ranges)
            merged_range = merge_ranges(m, r)
            if merged_range != 0:-1
                r = merged_range
                delete!(merged_ranges, m)
            end
        end
        push!(merged_ranges, r)
    end
    
    display(sum(length, merged_ranges))
end