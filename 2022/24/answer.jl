let input = readlines("input")
    
    dir = [CartesianIndex(1, 0); CartesianIndex(-1, 0); CartesianIndex(0, 1); CartesianIndex(0, -1)]
    tiles = Dict('.' => 0, '#' => 1, 'v' => 2, '^' => 4, '>' => 8, '<' => 16)
    A = vcat(map.(x -> tiles[x], collect.(input))'...)
    start = CartesianIndex(1, 2)
    finish = CartesianIndex(size(A, 1), size(A, 2)-1)
    
    function simulate(src; dst=zeros(Int, size(A)))
        for I in CartesianIndices(src)
            blizzard = src[I]
            if blizzard == 1
                dst[I] = 1
            elseif blizzard > 1
                for i in 1:length(dir)
                    k = 1 << i
                    if (blizzard & k) > 0
                        if src[I+dir[i]] == 1
                            dst[mod.((I+dir[i]).I, [2:size(src, 1)-1, 2:size(src, 2)-1])...] |= k
                        else
                            dst[I+dir[i]] |= k
                        end
                    end
                end
            end
        end
        return dst
    end
    
    function bfs(A::Matrix{T}, start::I, finish::I, neighborhood::Vector{I}) where T where I
        current = Set{I}()
        next = Set{I}()
        push!(current, start)
        
        finished = false
        steps = 0
        B = zeros(T, size(A))
        
        while !finished
            A .= simulate(A; dst=B)
            B .= 0
            steps += 1
            if isempty(current)
                error("no answer!")
            end
            
            while !isempty(current)
                c = pop!(current)
                
                if A[c] != 0
                    continue
                elseif c == finish
                    finished = true
                    break;
                end
                
                push!(next, c)
                
                for n in neighborhood
                    neighbor = c + n
                    if checkbounds(Bool, A, neighbor) && A[neighbor] != 1
                        push!(next, neighbor)
                    end
                end
            end
            current, next = next, current
        end
        return steps
    end
    
    # Part 1
    total_steps = bfs(A, start, finish, [CartesianIndex(0, 0); dir])
    display(total_steps)
    
    # Part 2
    total_steps += bfs(A, finish, start, [CartesianIndex(0, 0); dir])
    
    total_steps += bfs(A, start, finish, [CartesianIndex(0, 0); dir])
    display(total_steps)
end