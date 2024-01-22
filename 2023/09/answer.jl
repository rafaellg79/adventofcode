function read_history!(history, line)
    i = 1
    history[1] = 0
    s = 1
    for c in line
        if c == ' '
            i+=1
            history[i] = 0
            s = 1
        elseif c == '-'
            s = -1
        else
            history[i] = history[i] * 10 + s * Int(c-'0')
        end
    end
    return i
end

# Part 1

let lines = readlines("input")
    sum_of_forward_extrapolation = 0
    history = Array{Int}(undef, 100)
    
    for line in lines
        history_length = read_history!(history, line)
        current = @view history[1:history_length]
        d = 0
        while any(!=(0), current)
            d += last(current)
            current = diff(current)
        end
        
        sum_of_forward_extrapolation += d
    end
    
    display(sum_of_forward_extrapolation)
end

# Part 2

let lines = readlines("input")
    sum_of_backward_extrapolation = 0
    history = Array{Int}(undef, 100)
    diffs_buffer = similar(history)
    
    for line in lines
        history_length = read_history!(history, line)
        current = @view history[1:history_length]
        diffs = @view diffs_buffer[1:history_length]
        i = 0
        while any(!=(0), current)
            i += 1
            diffs[i] = first(current)
            current = diff(current)
        end
        
        backward_extrapolation = 0
        for d in @view diffs[i:-1:1]
            backward_extrapolation = d - backward_extrapolation
        end
        sum_of_backward_extrapolation += backward_extrapolation
    end
    
    display(sum_of_backward_extrapolation)
end