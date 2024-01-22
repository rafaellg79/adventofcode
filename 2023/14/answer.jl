function compute_total_load(A)
    round_rocks_per_row = count.(==('O'), eachrow(A))
    sum(prod, enumerate(reverse(round_rocks_per_row)))
end

function tilt_north!(A)
    for i in axes(A, 1), j in axes(A, 2)
        if A[i, j] == 'O'
            k = i-1
            while k > 0 && A[k, j] == '.'
                A[k, j], A[k+1, j] = A[k+1, j], A[k, j]
                k -=1
            end
        end
    end
    return A
end

# Part 1

let lines = readlines("input")
    matrix_of_characters = reduce(vcat, permutedims.(collect.(lines)))
    tilt_north!(matrix_of_characters)
    display(compute_total_load(matrix_of_characters))
end

# Part 2

function cycle!(A; B=copy(A))
    C, D = A, B
    for i in 1:4
        tilt_north!(C)
        permutedims!(D, C, [2 1])
        if iseven(i)
            reverse!(D)
        end
        C, D = D, C
    end
    return A
end

let lines = readlines("input")
    matrix_of_characters = reduce(vcat, permutedims.(collect.(lines)))
    # Arbitrary large number for the system to start to loop (tested manually)
    loop_start = 100
    buffer = copy(matrix_of_characters)
    for _ in 1:loop_start
        cycle!(matrix_of_characters; B=buffer)
    end
    
    # Find loop loads and size
    loads = Int[compute_total_load(matrix_of_characters)]
    state_at_loop_start = copy(matrix_of_characters)
    matrix_of_characters = cycle!(matrix_of_characters; B=buffer)
    while state_at_loop_start != matrix_of_characters
        push!(loads, compute_total_load(matrix_of_characters))
        cycle!(matrix_of_characters; B=buffer)
    end
    
    # Use loop stored loads to compute loop value at 1e9 
    display(loads[((Int(1e9) - loop_start) % length(loads))+1])
end