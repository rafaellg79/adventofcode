using Images

function tiles(P; dims=(11, 7))
    A = falses(dims)
    for p in P
        A[p] = true
    end
    return A
end

# Part 1

let lines = readlines("input")
    P = zeros(CartesianIndex{2}, length(lines))
    V = zeros(CartesianIndex{2}, length(lines))
    for (i, line) in enumerate(lines)
        P[i] = CartesianIndex(parse.(Int, split(line[3:findfirst(' ', line)], ','))...) + CartesianIndex(1, 1)
        V[i] = CartesianIndex(parse.(Int, split(line[findfirst('v', line)+2:end], ','))...)
    end
    
    P .+= 100V
    
    HQ_size = (101, 103)
    #HQ_size = (11, 7)
    P = [CartesianIndex(mod.(p.I, (1:HQ_size[1], 1:HQ_size[2]))) for p in P]
    Q1 = count(I -> I[1] < div(HQ_size[1], 2)+1 && I[2] < div(HQ_size[2], 2)+1, P)
    Q2 = count(I -> I[1] < div(HQ_size[1], 2)+1 && I[2] > div(HQ_size[2], 2)+1, P)
    Q3 = count(I -> I[1] > div(HQ_size[1], 2)+1 && I[2] < div(HQ_size[2], 2)+1, P)
    Q4 = count(I -> I[1] > div(HQ_size[1], 2)+1 && I[2] > div(HQ_size[2], 2)+1, P)
    display(Q1 * Q2 * Q3 * Q4)
end

# Part 2

let lines = readlines("input")
    P = zeros(CartesianIndex{2}, length(lines))
    V = zeros(CartesianIndex{2}, length(lines))
    for (i, line) in enumerate(lines)
        P[i] = CartesianIndex(parse.(Int, split(line[3:findfirst(' ', line)], ','))...) + CartesianIndex(1, 1)
        V[i] = CartesianIndex(parse.(Int, split(line[findfirst('v', line)+2:end], ','))...)
    end
    
    HQ_size = (101, 103)
    mkpath("temp")
    for n = 1:10000
        image = tiles([CartesianIndex(mod.((P[i]+n*V[i]).I, (1:HQ_size[1], 1:HQ_size[2]))) for i in 1:length(P)]; dims=HQ_size)'
        save("temp/$n.png", image)
    end
    display(7083)
end