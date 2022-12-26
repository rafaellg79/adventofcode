using DataStructures, Scanf

let input = readlines("input")
    function rearrange!(move!, stacks, instructions)
        for instruction in instructions
            _, total, from, to = @scanf instruction "move %d from %d to %d" Int Int Int
            move!(stacks, total, from, to)
        end
    end
    
    instructions = []
    stacks = Stack{Char}[]
        
    # Stack parser
    for (i, line) in enumerate(input)
        if(!isnothing(match(r"(\s\d+)+\s$", line)))
            
            for m in eachmatch(r"\d+", input[i])
                col = m.offset
                stack = Stack{Char}()
                for j = i-1:-1:1
                    if input[j][col] == ' '
                        break
                    end
                    push!(stack, input[j][col])
                end
                push!(stacks, stack)
            end
            
            instructions = @view input[i+2:end]
            break
        end
    end
    
    # Part 1
    let answer = "", S = deepcopy(stacks)
        rearrange!(S, instructions) do stacks, total, from, to
            for _ = 1:total
                push!(stacks[to], pop!(stacks[from]))
            end
        end
        
        answer = prod(first.(S))
        
        display(answer)
    end
    
    # Part 2
    let answer = "", S = deepcopy(stacks)
        rearrange!(S, instructions) do stacks, total, from, to
            popped_items = Stack{Char}()
            for _ = 1:total
                push!(popped_items, pop!(stacks[from]))
            end
            while !isempty(popped_items)
                push!(stacks[to], pop!(popped_items))
            end
        end
        
        answer = prod(first.(S))
        
        display(answer)
    end
end