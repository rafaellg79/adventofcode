let input = readline("input")
    horizontal = ones(Int, 4, 1)
    cross = [0 1 0; 1 1 1; 0 1 0]
    L = [1 0 0; 1 0 0; 1 1 1]
    vertical = ones(Int, 1, 4)
    square = [1 1; 1 1]
    shapes = [horizontal, cross, L, vertical, square]
    A = zeros(Int, 7, 10000)
    
    mutable struct Shape
        shape::Matrix{Int}
        pos::Vector{Int}
        is_still::Bool
    end
    
    spawn = (A, shape) -> A[shape.pos[1]:shape.pos[1]+size(shape.shape, 1)-1, shape.pos[2]:shape.pos[2]+size(shape.shape, 2)-1] .= shape.shape
    function jet(A, shape, dir)
        I = shape.pos[1]+size(shape.shape, 1)-1:-1:shape.pos[1]
        J = shape.pos[2]:shape.pos[2]+size(shape.shape, 2)-1
        inc = 1
        valid = true
        if dir == '<'
            I = shape.pos[1]:shape.pos[1]+size(shape.shape, 1)-1
            inc = -1
        end
        
        for i in I, j in J
            if A[i, j] == 1
                if (i == ((inc == 1) ? size(A, 1) : 1)) || A[i+inc, j] == 2
                    valid = false
                    break
                end
            end
        end
        
        if !valid
            return
        end
        
        for i in I, j in J
            if A[i, j] == 1
                A[i+inc, j] = A[i, j]
                A[i, j] = 0
            end
        end
        shape.pos[1]+=inc
    end
    function down(A, shape)
        I = shape.pos[1]:shape.pos[1]+size(shape.shape, 1)-1
        J = shape.pos[2]:shape.pos[2]+size(shape.shape, 2)-1
        
        if shape.pos[2] == 1
            shape.is_still = true
        else
            shape.is_still = mapreduce((up, down) -> up == 1 && down == 2, (a, b) -> a || b, A[I, J], A[I, J.-1])
        end
        
        if shape.is_still
            replace!(x -> x == 1 ? 2 : x, (@view A[I, J]))
        else
            for i in I, j in J
                if A[i, j] == 1
                    A[i, j-1] = A[i, j]
                    A[i, j] = 0
                end
            end
            shape.pos[2] -= 1
        end
    end
    
    # Part 1
    height = 1
    shape_ind = 0
    rocks = 0
    i = 0
    shape = Shape(Array{Int}(undef, 0, 0), [-1, -1], true)
    while rocks <= 2022
        i = (i % length(input)) + 1
        c = input[i]
        if shape.is_still
            highest = findlast(==(2), A[:, 1:height+4])
            height = isnothing(highest) ? 0 : highest[2]
            
            shape_ind = shape_ind % length(shapes) + 1
            shape.pos .= [3, height+4]
            shape.shape = shapes[shape_ind]
            shape.is_still = false
            
            spawn(A, shape)
            rocks += 1
        end
        jet(A, shape, c)
        down(A, shape)
    end
    display(height)
    
    # Part 2
    height = 1
    shape_ind = 0
    rocks = 0
    i = 0
    shape = Shape(Array{Int}(undef, 0, 0), [-1, -1], true)
    A = zeros(Int, 7, 20000)
    
    list_of_pieces = Tuple{Int, Int, Int}[]
    
    while height <= 19990
        i = (i % length(input)) + 1
        c = input[i]
        if shape.is_still
            highest = findlast(==(2), A[:, 1:height+4])
            height = isnothing(highest) ? 0 : highest[2]
            push!(list_of_pieces, (i, height, rocks))
            
            shape_ind = shape_ind % length(shapes) + 1
            shape.pos .= [3, height+4]
            shape.shape = shapes[shape_ind]
            shape.is_still = false
            
            spawn(A, shape)
            rocks += 1
        end
        jet(A, shape, c)
        down(A, shape)
    end
    
    max_rocks = 1000000000000
    n = findall((x)->first(x) == list_of_pieces[1724][1], list_of_pieces)
    n = n[2] - n[1]
    m = max_rocks ÷ n
    display(m * (list_of_pieces[1001+n][2]-list_of_pieces[1001][2])+list_of_pieces[max_rocks%n+1][2])
end