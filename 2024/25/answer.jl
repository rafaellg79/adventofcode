# Part 1

let lines = readlines("input")
    pins = []
    locks = []
    
    for i=1:8:length(lines)
        heights = zeros(Int, length(lines[i]))
        schematics = pins
        Y = i:i+6
        if lines[i][1] == '.'
            schematics = locks
            Y = i+6:-1:i
        end
        for x = 1:length(heights)
            n = 0
            for y in Y
                if lines[y][x] == '.'
                    break
                else
                    n+=1
                end
            end
            heights[x] = n
        end
        push!(schematics, Tuple(heights))
    end
    
    s = 0
    for pin in pins
        buffer = zeros(Int, length(pin))
        for lock in locks
            s += all(<=(7), broadcast!(+, buffer, pin, lock))
        end
    end
    display(s)
end