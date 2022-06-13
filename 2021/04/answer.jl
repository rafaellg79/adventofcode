open("input") do file
    draws = parse.(Int, split(readline(file), ','))
    boards = permutedims(reshape(readdlm(file, Int), 5, :, 5), [1, 3, 2])
    marks = zeros(Bool, size(boards))
    scores = Int[]
    
    bingo = (marks) -> any(all(marks, dims=1)) || any(all(marks, dims=2))
    
    for n in draws
        for tile in findall(==(n), boards)
            marks[tile] = true
            if bingo(@view marks[:, :, tile[3]])
                push!(scores, sum(.!marks[:, :, tile[3]] .* boards[:, :, tile[3]]) * n)
                boards[:, :, tile[3]] .= -1
            end
        end
    end
    
    display(scores[1])
    display(scores[end])
end