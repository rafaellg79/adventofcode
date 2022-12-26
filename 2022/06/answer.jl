let input = readline("input")

    is_marker(input, pos, len) = 
    length(unique(input[max(pos-len+1, 1):pos])) == len
    
    #Part 1
    display(findfirst(x->is_marker(input, x, 4), 1:length(input)))
    
    #Part 2
    display(findfirst(x->is_marker(input, x, 14), 1:length(input)))
end