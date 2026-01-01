# Part 1

let lines = readlines("input")
    ops_dict = Dict("+"=>+, "-"=>-, "*"=>*, "/"=>div)
    last_line = filter(!isempty, split(lines[end], " "))
    ops = [ops_dict[s] for s in last_line]
    v = [(op == +) ? 0 : 1 for op in ops]
    for line in lines[1:end-1]
        n = filter(!isempty, split(line, " "))
        for i in 1:length(ops)
            v[i] = ops[i](v[i], parse(Int, n[i]))
        end
    end
    
    display(sum(v))
end

# Part 2

let lines = readlines("input")
    # Create an array to store the operations
    ops_dict = Dict("+"=>+, "*"=>*)
    last_line = filter(!isempty, split(lines[end], " "))
    ops = [ops_dict[s] for s in last_line]
    
    # Trackers for column, operation and partial sum
    numbers = []
    op_index = 1
    n = (ops[1] == +) ? 0 : 1
    s = 0
    
    for i in 1:length(lines[1])
        if all(line -> isspace(line[i]), lines)
            op_index += 1
            s += n
            n = (ops[op_index] == +) ? 0 : 1
            continue
        end
        n = ops[op_index](parse(Int, join([line[i] for line in lines[1:end-1]])), n)
    end
    
    s += n
    
    display(s)
end