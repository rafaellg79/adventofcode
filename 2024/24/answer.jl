const op_map = Dict("AND"=> &, "XOR" => xor, "OR" => |, )

# Part 1

function eval_gate(wires, op, wire1, wire2)
    val1 = wires[wire1]
    if typeof(val1) <: Tuple
        val1 = eval_gate(wires, val1...)
    end
    val2 = wires[wire2]
    if typeof(val2) <: Tuple
        val2 = eval_gate(wires, val2...)
    end
    return op(val1, val2)
end

function eval_gate(wires, key)
    if typeof(wires[key]) <: Integer
        return wires[key]
    end
    return eval_gate(wires, wires[key]...)
end

function eval_wires(wires, prefix; evaluation_function=eval_gate)
    N = []
    for i = 0:99
        key = prefix * lpad("$i", 2, '0')
        if haskey(wires, key)
            push!(N, evaluation_function(wires, key))
        end
    end
    return N
end

function wires_to_int(X; f=reverse)
    parse(Int, "0b" * join(f(X)))
end

let lines = readlines("input")
    divisor = findfirst(isempty, lines)
    wires = Dict()
    for line in lines[1:divisor-1]
        wire, value = split(line, ':')
        wires[wire] = parse(Int, value)
    end
    
    for line in lines[divisor+1:end]
        wire1, op, wire2, _, output = split(line, ' ')
        wires[output] = (op_map[op], wire1, wire2)
    end
    
    Z = eval_wires(wires, 'z')
    display(wires_to_int(Z))
end

# Part 2

# This is just a debug function to display the wire tree to help understand what's being output.
# It's useful to assert that there aren't any useless gates like x00 XOR x00 which is always 0 nor that there are weird gates used for several outputs.
# Knowing it's an add circuit without any 'bloat' gates makes the problem much easier.
# Use it with the command below after processing all lines to `display` the tree of all 'z' starting wires as a vector of strings (actually Vector{Any} containing only String elements):
# display(eval_wires(wires, 'z'; evaluation_function=eval_gate_string))
function eval_gate_string(wires, op, wire1, wire2)
    val1 = wires[wire1]
    if typeof(val1) <: Tuple
        val1 = eval_gate_string(wires, val1...)
    else
        val1=wire1
    end
    val2 = wires[wire2]
    if typeof(val2) <: Tuple
        val2 = eval_gate_string(wires, val2...)
    else
        val2 = wire2
    end
    return "($val1 $(op) $val2)"
end

function eval_gate_string(wires, key)
    if typeof(wires[key]) <: Integer
        return key
    end
    return eval_gate_string(wires, wires[key]...)
end

let lines = readlines("input")
    divisor = findfirst(isempty, lines)
    wires = Dict()
    for line in lines[1:divisor-1]
        wire, value = split(line, ':')
        wires[wire] = parse(Int, value)
    end
    
    for line in lines[divisor+1:end]
        wire1, op, wire2, _, output = split(line, ' ')
        wires[output] = (op_map[op], wire1, wire2)
    end
    
    X = eval_wires(wires, 'x')
    Y = eval_wires(wires, 'y')
    
    wires_ones = copy(wires)
    for (key, val) in wires_ones
        if typeof(val) <: Integer
            wires_ones[key] = 1
        end
    end
    
    # sometime I might add an auto solver here, but for now I will just switch the gates and assert the answer is correct...
    
    answer = Dict("kdh" => "hjf", "z35" => "sgj", "z14" => "vss", "z31" => "kpp")
    
    for (key, val) in answer
        wires[key], wires[val] = wires[val], wires[key]
    end
    
    Z = eval_wires(wires, 'z')
    
    @assert parse(Int, "0b" * reverse(join(Z))) == parse(Int, "0b" * reverse(join(X))) + parse(Int, "0b" * reverse(join(Y)))
    
    display(join(sort!(append!(collect(keys(answer)), collect(values(answer)))), ','))
end