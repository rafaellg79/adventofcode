let input = readdlm("input")
    X = 1
    clock = 1

    # Part 1
    signal_strength = [];
    update! = (signal_strength, X, clock) ->  begin push!(signal_strength, X*clock); clock+1 end
    
    for i = 1:size(input, 1)
        if input[i, 1] == "addx"
            clock = update!(signal_strength, X, clock)
            clock = update!(signal_strength, X, clock)
            X += input[i, 2]
        else
            clock = update!(signal_strength, X, clock)
        end
    end
    
    display(sum(signal_strength[20:40:220]))

    # Part 2
    screen = ""
    X = 1
    clock = 0
    
    draw = (X, clock) -> (abs(X - clock % 40) <= 1 ? "#" : ".") * 
                         ((clock + 1) % 40 == 0    ? "\n" : "")
    
    for i = 1:size(input, 1)
        if input[i, 1] == "addx"
            screen *= draw(X, clock)
            clock += 1
            screen *= draw(X, clock)
            clock += 1
            X += input[i, 2]
        else
            screen *= draw(X, clock)
            clock += 1
        end
    end
    
    print(screen)
end