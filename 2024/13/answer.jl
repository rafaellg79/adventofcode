function parse_file(lines)
    A = zeros(Int, div(length(lines), 4)+1, 2)
    B = zeros(Int, div(length(lines), 4)+1, 2)
    P = zeros(Int, div(length(lines), 4)+1, 2)
    for i = 0:div(length(lines), 4)
        n = 4i
        a0 = parse(Int, lines[n+1][13:14])
        a1 = parse(Int, lines[n+1][19:20])
        
        A[i+1, :] .= [a0, a1]
        
        b0 = parse(Int, lines[n+2][13:14])
        b1 = parse(Int, lines[n+2][19:20])
        
        B[i+1, :] .= [b0, b1]
        
        _, p0, p1 = split(lines[n+3], '=')
        
        p0 = parse(Int, p0[1:(findfirst(==(','), p0)-1)])
        p1 = parse(Int, p1)
        
        P[i+1, :] .= [p0, p1]
    end
    return A, B, P
end

# Part 1

let lines = readlines("input")
    A, B, P = parse_file(lines)
    
    cost = 0
    
    for i = 1:size(A, 1)
        sol = [(A[i, :]) B[i, :]] \ P[i, :]
        if 0 <= sol[1] <= 100 && 0 <= sol[2] <= 100 && all(x -> isapprox(x-round(x), 0, atol=0.01), sol)
            cost += round(Int, 3sol[1] + sol[2])
        end
    end
    display(cost)
end

# Part 2

let lines = readlines("input")
    A, B, P = parse_file(lines)
    
    cost = 0
    
    for i = 1:size(A, 1)
        sol = [A[i, :] B[i, :]] \ (P[i, :].+10000000000000)
        if all(x -> isapprox(x-round(x), 0, atol=0.01), sol)
            cost += round(Int, 3sol[1] + sol[2])
        end
    end
    
    display(cost)
end
