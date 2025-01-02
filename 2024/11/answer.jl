# Part 1

function blink(n)
    if iseven(length(n))
        return ["$(parse(Int, n[1:div(end, 2)]))", "$(parse(Int, n[div(end, 2)+1:end]))"]
    elseif iszero(parse(Int, n))
        return ["1"]
    else
        return ["$(parse(Int, n)*2024)"]
    end
end

let lines = readlines("input")
    v = split(lines[1])
    
    for m = 1:25
        next = []
        for n in v
            m = blink(n)
            append!(next, blink(n))
        end
        v = next
    end
    display(length(v))
end

# Part 2

let lines = readlines("input")
    v = split(lines[1])
    weights = Dict(v .=> 1)
    
    for m = 1:75
        next = []
        next_weights = Dict()
        for n in v
            m = blink(n)
            for k in m
                next_weights[k] = get(next_weights, k, 0) + weights[n]
            end
            append!(next, m)
        end
        v = Set(next)
        weights = next_weights
    end
    display(sum(values(weights)))
end