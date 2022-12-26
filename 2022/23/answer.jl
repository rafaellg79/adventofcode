using ImageFiltering

let input = readlines("input")
    
    tiles = Dict('.' => 0, '#' => -1)
    A = vcat(map.(x -> tiles[x], collect.(input))'...)
    
    starting_moves = [CartesianIndex(-1, 0); CartesianIndex(1, 0); CartesianIndex(0, -1); CartesianIndex(0, 1)]
    starting_tests = [
                      [CartesianIndex(0, -1); CartesianIndex(0, 0); CartesianIndex(0, 1)],
                      [CartesianIndex(0, -1); CartesianIndex(0, 0); CartesianIndex(0, 1)],
                      [CartesianIndex(-1, 0); CartesianIndex(0, 0); CartesianIndex(1, 0)],
                      [CartesianIndex(-1, 0); CartesianIndex(0, 0); CartesianIndex(1, 0)]
                     ]
    
    # Part 1
    moves = copy(starting_moves)
    tests = copy(starting_tests)
    current = collect(padarray(A, ImageFiltering.Fill(0, (11, 11))))
    next = zeros(Int, size(current))
    for n = 1:10
        for I in CartesianIndices(current)
            if current[I] == -1
                if count(==(0), current[I[1]-1:I[1]+1, I[2]-1:I[2]+1]) == 8
                    next[I] = -1
                    continue
                end
                moved = false
                for (move_ind, move) in enumerate(moves)
                    J = I+move
                    if all(x -> current[J+x]==(0), tests[move_ind])
                        if next[J] == 0
                            next[J] = move_ind
                            moved = true
                            break
                        else
                            next[I] = -1
                            if next[J] > 0
                                next[J-moves[next[J]]] = -1
                                next[J] = -2
                                moved = true
                                break
                            end
                        end
                    end
                end
                if !moved
                    next[I] = -1
                end
            end
        end
        current .= next
        current[current.>0] .= -1
        current[current.==-2] .= 0
        next .= 0
        circshift!(moves, -1)
        circshift!(tests, -1)
    end
    
    x0 = findfirst(<(0), current)[2]
    x1 = findlast(<(0), current)[2]
    y0 = findfirst(<(0), current')[2]
    y1 = findlast(<(0), current')[2]
    
    display(count(>=(0), current[y0:y1, x0:x1]))
    
    # Part 2
    total_moves = 10
    while true
        for I in CartesianIndices(current)
            if current[I] == -1
                if count(==(0), current[I[1]-1:I[1]+1, I[2]-1:I[2]+1]) == 8
                    next[I] = -1
                    continue
                end
                moved = false
                for (move_ind, move) in enumerate(moves)
                    J = I+move
                    if all(x -> current[J+x]==(0), tests[move_ind])
                        if next[J] == 0
                            next[J] = move_ind
                            moved = true
                            break
                        else
                            next[I] = -1
                            if next[J] > 0
                                next[J-moves[next[J]]] = -1
                                next[J] = -2
                                moved = true
                                break
                            end
                        end
                    end
                end
                if !moved
                    next[I] = -1
                end
            end
        end
        
        next[next.>0] .= -1
        next[next.==-2] .= 0
        total_moves+=1
        if current == next
            break
        end
        current .= next
        circshift!(moves, -1)
        circshift!(tests, -1)
        
        x0 = findfirst(<(0), current)[2]
        x1 = findlast(<(0), current)[2]
        y0 = findfirst(<(0), current')[2]
        y1 = findlast(<(0), current')[2]
        
        if x0 == 1 || y0 == 1 || x1 == size(current, 2) || y1 == size(current, 1)
            current = collect(padarray(current, ImageFiltering.Fill(0, (1, 1))))
            next = zeros(Int, size(current))
        else
            next .= 0
        end
    end
    display(total_moves)
end