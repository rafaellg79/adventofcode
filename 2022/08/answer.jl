let input = readlines("input")
    A = transpose(hcat(map(c -> parse.(Int, c), collect.(input))...))

    # Part 1
    visibles = falses(size(A))
    visibles[[1, end], :] .= true
    visibles[:, [1, end]] .= true
    
    for i = 2:(size(A, 1)-1), j = 2:(size(A, 2)-1)
        if all(A[i, j] .> A[1:i-1, j]) || all(A[i, j] .> A[i, 1:j-1]) || all(A[i, j] .> A[i+1:end, j]) || all(A[i, j] .> A[i, j+1:end])
            visibles[i, j] = true
        end
    end
    display(count(visibles))

    # Part 2
    scenic_score = (A, d) -> last.(accumulate((a, b) -> [b; ones(Int, b+1); a[b+3:end-1].+1; a[b+2]], A; dims=d, init=zeros(Int, 12)))
    display(maximum(scenic_score(A, 1) .* scenic_score(A, 2) .* reverse!(scenic_score(reverse(A; dims=1), 1), dims=1) .* reverse!(scenic_score(reverse(A, dims=2), 2), dims=2)))
end