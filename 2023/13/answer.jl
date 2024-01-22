function mirrored_diff_at(A::AbstractArray{T, N}, dim, i) where {T, N}
    len = min(i-1, size(A, dim)-(i+1))
    
    indices_left = ntuple(d -> (d==dim) ? (i-len:i) : axes(A, d), N)
    indices_right = ntuple(d -> (d==dim) ? (i+1+len:-1:i+1) : axes(A, d), N)
    
    return count(A[indices_left...] .!= A[indices_right...])
end

function find_ndiff_reflection_line(A, n)
    for dim in 1:ndims(A), i = 1:(size(A, dim)-1)
        if mirrored_diff_at(A, dim, i) == n
            return (dim, i)
        end
    end
    return nothing
end

let lines = readlines("input")
    score = 0
    matrix_start = [0; findall(isempty, lines); length(lines)+1]
    for (start, finish) in zip(matrix_start, matrix_start[2:end])
        matrix = reduce(vcat, permutedims.(collect.(lines[start+1:finish-1])))
        weights = (100, 1)
        reflected_line = find_ndiff_reflection_line(matrix, 0)
        if isnothing(reflected_line)
            continue
        end
        score += weights[reflected_line[1]] * reflected_line[2]
    end
    
    display(score)
end

let lines = readlines("input")
    score = 0
    matrix_start = [0; findall(isempty, lines); lastindex(lines)+1]
    for (start, finish) in zip(matrix_start, matrix_start[2:end])
        matrix = reduce(vcat, permutedims.(collect.(lines[start+1:finish-1])))
        weights = (100, 1)
        reflected_line = find_ndiff_reflection_line(matrix, 1)
        if isnothing(reflected_line)
            continue
        end
        score += weights[reflected_line[1]] * reflected_line[2]
    end
    
    display(score)
end