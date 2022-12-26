using DelimitedFiles

let A = readdlm("input")
    B = zeros(Int, size(A))
    
    @views map!(x->x[1]-'A'+1, B[:, 1], A[:, 1])
    @views map!(x->x[1]-'X'+1, B[:, 2], A[:, 2])
    
    # Part 1
    let score = 0
        score_matrix = [3 6 0;0 3 6;6 0 3]
        for i in 1:size(B, 1)
            score += B[i, 2] + score_matrix[B[i, 1], B[i, 2]]
        end
        display(score)
    end
    
    # Part 2
    let score = 0
        decision_matrix = [3 1 2; 1 2 3; 2 3 1]
        for i in 1:size(B, 1)
            score += decision_matrix[B[i, 1], B[i, 2]] + 3*(B[i, 2]-1)
        end
        
        display(score)
    end
end