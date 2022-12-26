let input = parse.(Int, readlines("input"))
    function mix(A; mixes=1)
        B = collect(1:length(A))
        for _ = 1:mixes
            for (i, n) in enumerate(A)
                j = findfirst(==(i), B)
                deleteat!(B, j)
                k = mod(j+n, 1:length(B))
                insert!(B, k, i)
            end
        end
        return A[B]
    end
    
    # Part 1
    A = mix(input)
    x = findfirst(==(0), A)
    grove_coordinates = A[mod.([x+1000; x+2000; x+3000], Ref(1:length(A)))]
    display(sum(grove_coordinates))
    
    # Part 2
    key = 811589153
    B = mix(input .* key; mixes=10)
    x = findfirst(==(0), B)
    grove_coordinates = B[mod.([x+1000; x+2000; x+3000], Ref(1:length(B)))]
    display(sum(grove_coordinates))
end

#=
let input = parse.(Int, readlines("input"))
    function mix(A; mixes=1)
        B = collect(1:length(A))
        for _ = 1:mixes
            for (i, n) in enumerate(A)
                j = findfirst(==(i), B)
                k = mod(j+n, 1:(length(B)-1))
                C = @view B[j:k]
                if k > j
                    if n > 0
                        C = @view B[j:k]
                    elseif n < 0 
                        C = @view B[[1:j; k:end]]
                    end
                elseif k < j
                    if n < 0
                        C = @view B[k:j]
                    elseif n > 0 
                        C = @view B[[1:k; j:end]]
                    end
                end
                circshift!(C, C, sign(-n))
            end
        end
        return A[B]
    end
    
    # Part 1
    A = mix(input)
    x = findfirst(==(0), A)
    grove_coordinates = A[mod.([x+1000; x+2000; x+3000], Ref(1:length(A)))]
    display(sum(grove_coordinates))
    
    # Part 2
    key = 811589153
    B = mix(input .* key; mixes=10)
    x = findfirst(==(0), B)
    grove_coordinates = B[mod.([x+1000; x+2000; x+3000], Ref(1:length(B)))]
    display(sum(grove_coordinates))
end=#