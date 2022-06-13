using DelimitedFiles

A = readdlm("input", ','; skipblanks=false)
separator = findfirst(isempty, A[:,1])

dots_pos = A[1:separator-1, :].+1
fold_instructions = Matrix{Any}(hcat(split.(A[separator+1:end, 1], '=')...))
fold_instructions[1, :] .= ["$(last(dim))" for dim in fold_instructions[1, :]]
fold_instructions[2, :] .= parse.(Int, fold_instructions[2, :]).+1

function fold_up(dots, row)
    num_rows = size(dots, 1)
    if 2row <= num_rows
        return reverse(fold_up(reverse(dots, dims=2), num_rows - row), dims=2)
    end
    
    folded_dots = copy(dots[1:row-1, :])
    for (i, j) in zip(row-1:-1:1, row+1:size(dots, 1))
        folded_dots[i,:] .|= dots[j, :]
    end
    
    return folded_dots
end

fold_left(dots, row) = fold_up(dots', row)'

dots = zeros(Bool, maximum(dots_pos[:, 2]), maximum(dots_pos[:, 1]))
for (x, y) in zip(dots_pos[:, 1], dots_pos[:, 2])
    dots[y, x] = true
end

instruction_to_function = Dict{String, Function}("x" => fold_left, "y" => fold_up)

display(count(instruction_to_function[fold_instructions[1, 1]](dots, fold_instructions[2, 1])))

let folded_dots = copy(dots)
    for i = 1:size(fold_instructions, 2)
        folded_dots = instruction_to_function[fold_instructions[1, i]](folded_dots, fold_instructions[2, i])
    end
    display(folded_dots)
end