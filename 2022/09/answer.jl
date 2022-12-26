let input = readdlm("input")
    head_pos = [1; 1]
    tail_pos = [1; 1]
    
    dir = Dict{String, Vector{Int}}(
        "R" => [ 1; 0],
        "L" => [-1; 0],
        "D" => [ 0;-1],
        "U" => [ 0; 1],
        )

    # Part 1
    visited = Set{Tuple{Int, Int}}()
    push!(visited, Tuple(tail_pos))
    
    function move!(h, t, d)
        h .+= d
        temp = (h.-t)
        if maximum(abs.(temp)) <= 1
            return
        end
        temp ./= max.(abs.(temp), 1)
        t .+= temp
    end
    
    for i = 1:size(input, 1)
        d = dir[input[i, 1]]
        for j = 1:input[i, 2]
            move!(head_pos, tail_pos, d)
            push!(visited, Tuple(tail_pos))
        end
    end
    display(length(visited))

    # Part 2
    visited = Set{Tuple{Int, Int}}()
    knots_pos = Vector{Int}[]
    for _ = 1:10
        push!(knots_pos, [1; 1])
    end
    
    for i = 1:size(input, 1)
        d = dir[input[i, 1]]
        for j = 1:input[i, 2]
            move!(knots_pos[1], knots_pos[2], d)
            for k = 2:length(knots_pos)-1
                move!(knots_pos[k], knots_pos[k+1], [0; 0])
            end
            push!(visited, Tuple(last(knots_pos)))
        end
    end
    
    display(length(visited))
end