function mix(a, b)
    return xor(a, b)
end

function prune(n)
    return n % 16777216
end

function next_secret(secret_number)
    
    n = prune(mix(64secret_number, secret_number))
    n = prune(mix(div(n, 32, RoundDown), n))
    n = prune(mix(2048n, n))
    return n
end

# Part 1

let lines = readlines("input")
    s = 0
    for line in lines
        n = parse(Int, line)
        for _ in 1:2000
            n = next_secret(n)
        end
        s += n
    end
    display(s)
end

# Part 2

# join 4 numbers -9 <= a, b, c, d <= 9 into a single number n
function encode(a, b, c, d)
    return mod(a, 0:18) + mod(b, 0:18)*19 + mod(c, 0:18)*19^2 + mod(d, 0:18)*19^3 + 1
end

let lines = readlines("input")
    daily_secret_numbers = 2000
    secret_numbers = zeros(Int32, length(lines), daily_secret_numbers+1)
    s = 0
    for (i, line) in enumerate(lines)
        n = parse(Int32, line)
        secret_numbers[i, 1] = n
        for j in 2:daily_secret_numbers
            n = next_secret(n)
            secret_numbers[i, j] = n
        end
    end
    
    bananas = zeros(Int8, size(secret_numbers))
    changes = zeros(Int8, size(secret_numbers))
    for i in 1:size(secret_numbers, 1)
        bananas[:, 1] .= secret_numbers[:, 1].%10
        for j in 2:size(secret_numbers, 2)
            bananas[i, j] = secret_numbers[i, j]%10
            changes[i, j] = bananas[i, j] - bananas[i, j-1]
        end
    end
    
    sequences_bananas = fill(Int8(-1), 19^4*size(changes, 1))
    for i in 1:size(changes, 1)
        base_key = (i-1) * 19^4
        for j in 4:size(changes, 2)
            sequence_key = base_key + encode(changes[i, j-3:j]...)
            if sequences_bananas[sequence_key] < 0
                sequences_bananas[sequence_key] = bananas[i, j]
            end
        end
    end
    
    max_bananas = 0
    
    for a in -9:9, b in -9:9, c in -9:9, d in -9:9
        sequence_bananas = 0
        sequence_key = encode(a, b, c, d)
        for i in 1:size(changes, 1)
            if sequences_bananas[sequence_key+(i-1)*19^4] >= 0
                sequence_bananas += sequences_bananas[sequence_key+(i-1)*19^4]
            end
        end
        max_bananas = max(sequence_bananas, max_bananas)
    end
    
    display(max_bananas)
end