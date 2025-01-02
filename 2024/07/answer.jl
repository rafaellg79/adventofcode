# Part 1

function combinations(v, ops)
    l = length(ops)
    C = zeros(Int, l^(length(v)-1))
    C[1] = v[1]
    for i = 2:length(v)
        for j = (l^(i-2)-1):-1:0
            for k = l:-1:1
                C[l*j+k] = ops[k](C[j+1], v[i])
            end
        end
    end
    return C
end

let lines = readlines("input")
    total_calibration = 0
    for line in lines
        left, right = split(line, ':')
        left = parse(Int, left)
        right = parse.(Int, split(right))
        v = combinations(right, [+; *])
        if left in v
            total_calibration += left
        end
    end
    display(total_calibration)
end

# Part 2

function concatenate(a, b)
    d = floor(Int, log10(b))+1
    return a*10^d + b
end

let lines = readlines("input")
    total_calibration = 0
    for line in lines
        left, right = split(line, ':')
        left = parse(Int, left)
        right = parse.(Int, split(right))
        v = combinations(right, [+; *; concatenate])
        if left in v
            total_calibration += left
        end
    end
    display(total_calibration)
end