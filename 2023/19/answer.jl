mutable struct Rating
    x::Int
    m::Int
    a::Int
    s::Int
end

function Rating(r::Rating)
    return Rating(r.x, r.m, r.a, r.s)
end

function get_op(op)
    if op == '>'
        return >
    elseif op == '<'
        return <
    else
        error()
    end
end

# Part 1

let lines = readlines("input")
    score = 0
    
    workflow = Dict{String, Vector{Function}}()
    
    for line in lines[1:findfirst(isempty, lines)-1]
        id = line[1:findfirst(==('{'), line)-1]
        rules = split(line[length(id)+2:end-1], ',')
        default = rules[end]
        rules = map(rules[1:end-1]) do (rule)
            category = rule[1]
            op = rule[2]
            
            separator = findfirst(==(':'), rule)
            value = parse(Int, rule[3:separator-1])
            next = rule[separator+1:end]
            return (rating) -> begin get_op(op)(getproperty(rating, Symbol(category)), value) ? next : nothing end
        end
        workflow[id] = vcat(rules, (rating) -> default)
    end
    
    ratings = Vector{Rating}(undef, length(lines)-findfirst(isempty, lines))
    for (i, line) in enumerate(lines[findfirst(isempty, lines)+1:end])
        val = split(line[2:end-1], ',')
        ratings[i] = Rating([parse(Int, v[3:end]) for v in val]...)
    end
    
    for rating in ratings
        current = "in"
        while haskey(workflow, current)
            rules = workflow[current]
            for rule in rules
                next = rule(rating)
                if isnothing(next)
                    continue
                else
                    current = next
                    break
                end
            end
        end
        if current == "A"
            score += rating.x + rating.m + rating.a + rating.s
        end
    end
    
    display(score)
end

# Part 2

let lines = readlines("input")
    score = 0
    
    workflow = Dict{String, Vector{Tuple{Char, Char, Int64, SubString{String}}}}()
    
    for line in lines[1:findfirst(isempty, lines)-1]
        id = line[1:findfirst(==('{'), line)-1]
        rules = split(line[length(id)+2:end-1], ',')
        default = rules[end]
        min_rating = Rating(1, 1, 1, 1)
        max_rating = Rating(4000, 4000, 4000, 4000)
        rules = map(rules[1:end-1]) do (rule)
            category = rule[1]
            op = rule[2]
            
            separator = findfirst(==(':'), rule)
            value = parse(Int, rule[3:separator-1])
            next = rule[separator+1:end]
            
            return (category, op, value, next)
        end
        workflow[id] = vcat(rules, ('-', '-', 0, default))
    end
    
    next = Tuple{Rating, Rating, String}[(Rating(1, 1, 1, 1), Rating(4000, 4000, 4000, 4000), "in")]
    while !isempty(next)
        (min_rating, max_rating, current_id) = popfirst!(next)
        rules = workflow[current_id]
        for (category, op, value, next_id) in rules
            if op == '>'
                rating = Rating(min_rating)
                setproperty!(rating, Symbol(category), value+1)
                if next_id == "A"
                    score += prod(((max_rating.x - rating.x)+1, (max_rating.m - rating.m)+1, (max_rating.a - rating.a)+1, (max_rating.s - rating.s)+1))
                elseif next_id != "R"
                    push!(next, (rating, Rating(max_rating), next_id))
                end
                
                setproperty!(max_rating, Symbol(category), value)
            elseif op == '<'
                rating = Rating(max_rating)
                setproperty!(rating, Symbol(category), value-1)
                if next_id == "A"
                    score += prod(((rating.x - min_rating.x)+1, (rating.m - min_rating.m)+1, (rating.a - min_rating.a)+1, (rating.s - min_rating.s)+1))
                elseif next_id != "R"
                    push!(next, (Rating(min_rating), rating, next_id))
                end
                
                setproperty!(min_rating, Symbol(category), value)
            else
                if next_id == "A"
                    score += prod(((max_rating.x - min_rating.x)+1, (max_rating.m - min_rating.m)+1, (max_rating.a - min_rating.a)+1, (max_rating.s - min_rating.s)+1))
                elseif next_id != "R"
                    push!(next, (min_rating, max_rating, next_id))
                end
            end
        end
    end
    
    display(score)
end