function max_non_continuous_sequence(digits, length)
    m = zeros(Int, length)
    return max_non_continuous_sequence!(m, digits, length)
end

function max_non_continuous_sequence!(m, digits, length)
    k = 1
    for i = 1:length
        m[i], index = findmax(digits[k:end-(length-i)])
        k += index
    end
    return m
end

# Part 1

let lines = readlines("input")
    n = 0
    for line in lines
        v = parse.(Int, collect(line))
        m1, m2 = max_non_continuous_sequence(v, 2)
        n += 10*m1 + m2
    end
    display(n)
end

# Part 2

let lines = collect.(readlines("input"))
    n = 0
    v = zeros(Int8, 100)
    m = zeros(Int, 12)
    for line in lines
        map!(x->x-'0', v, line)
        max_non_continuous_sequence!(m, (@view v[1:length(line)]), 12)
        n += sum((x) -> x[2]*10 ^ (12-x[1]), enumerate(m))
    end
    display(n)
end