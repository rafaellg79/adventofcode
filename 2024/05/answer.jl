# Part 1

let lines = readlines("input")
    rules = trues(100, 100)
    divisor = findfirst(isempty, lines)
    
    for line in lines[1:divisor-1]
        previous, next = parse.(Int, split(line, '|'))
        rules[next, previous] = false
    end
    
    s = 0
    
    for line in lines[divisor+1:end]
        pages = parse.(Int, split(line, ','))
        valid = true
        for i in 1:length(pages)-1, j in i:length(pages)
            if !rules[pages[i], pages[j]]
                valid = false
                break
            end
        end
        if valid
            s += pages[div(1+length(pages), 2)]
        end
    end
    
    display(s)
end

# Part 2

let lines = readlines("input")
    rules = trues(100, 100)
    divisor = findfirst(isempty, lines)
    
    for line in lines[1:divisor-1]
        previous, next = parse.(Int, split(line, '|'))
        rules[next, previous] = false
    end
    
    s = 0
    
    for line in lines[divisor+1:end]
        pages = parse.(Int, split(line, ','))
        valid = true
        for i in 1:length(pages)-1, j in i:length(pages)
            if !rules[pages[i], pages[j]]
                valid = false
                break
            end
        end
        if !valid
            sort!(pages; lt = (a, b) -> rules[a, b])
            s += pages[div(1+length(pages), 2)]
        end
    end
    
    display(s)
end