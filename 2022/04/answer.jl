let input = readlines("input")
    
    section_pairs = split.(input, ',')
    range_pairs = map.(x -> UnitRange(parse.(Int, split(x, '-'))...), section_pairs)
    
    # Part 1
    let answer = 0
        for pair in range_pairs
            intersection = intersect(pair[1], pair[2])
            if(intersection == pair[1] || intersection == pair[2])
                answer += 1
            end
        end
        display(answer)
    end
    
    # Part 2
    let answer = 0
        for pair in range_pairs
            intersection = intersect(pair[1], pair[2])
            if(length(intersection) > 0)
                answer += 1
            end
        end
        display(answer)
    end
end