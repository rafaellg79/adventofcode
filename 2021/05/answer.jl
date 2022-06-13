open("input") do file
    A = zeros(Int, 1000, 1000)
    B = copy(A)
    while !eof(file)
        diagonal = false
        line = readline(file)
        x1, y1, x2, y2 = parse.(Int, split(line, @r_str(" -> |,")))
        if x1 != x2 && y1 != y2
            diagonal = true
        end
        
        x, y = x1+1, y1+1
        dx, dy = sign(x2 - x1), sign(y2 - y1)
        A[y, x] += !diagonal
        while x != x2+1 || y != y2+1
            x += dx
            y += dy
            A[y, x] += !diagonal
            B[y, x] += 1
        end
    end
    display(count(>(1), A))
    display(count(>(1), B))
end