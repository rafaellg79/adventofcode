function Combo(operand, A, B, C)
    if operand == 4
        return A
    elseif operand == 5
        return B
    elseif operand == 6
        return C
    elseif operand == 7
        error("invalid operand")
    else
        return operand
    end
end

function run(A, B, C, instructions)
    instruction_pointer = 1
    out = ""
    while instruction_pointer <= length(instructions)
        opcode = instructions[instruction_pointer]
        operand = instructions[instruction_pointer+1]
        combo = Combo(operand, A, B, C)
        if opcode == 0
            A = trunc(Int, A / (2^combo))
        elseif opcode == 1
            B = xor(B, operand)
        elseif opcode == 2
            B = combo % 8
        elseif opcode == 3
            if A != 0
                instruction_pointer = operand+1
                continue
            end
        elseif opcode == 4
            B = xor(B, C)
        elseif opcode == 5
            out *= "$(combo%8),"
        elseif opcode == 6
            B = trunc(Int, A / (2^combo))
        elseif opcode == 7
            C = trunc(Int, A / (2^combo))
        end
        instruction_pointer += 2
    end
    return out[1:end-1]
end

# Part 1

let lines = readlines("input")
    A = parse(Int, split(lines[1], ':')[2])
    B = parse(Int, split(lines[2], ':')[2])
    C = parse(Int, split(lines[3], ':')[2])
    instructions = parse.(Int, split(split(lines[end], ':')[2], ','))
    println(run(A, B, C, instructions))
end

# Part 2
let lines = readlines("input")
    A = parse(Int, split(lines[1], ':')[2])
    B = parse(Int, split(lines[2], ':')[2])
    C = parse(Int, split(lines[3], ':')[2])
    instructions = parse.(Int, split(split(lines[end], ':')[2], ','))
    
    multipliers = zeros(Int, length(instructions))
    exponents = 8 .^ collect((length(instructions)-1):-1:0)
    
    i = 1
    while i <= length(multipliers)
        valid = false
        A = sum(multipliers[1:i-1] .* exponents[1:i-1])
        for n = multipliers[i]:7
            output = run(A+n*exponents[i], B, C, instructions)
            program = parse.(Int, split(output, ','))
            if A==0 && n == 0
                continue
            elseif program[end-(i-1):end] == instructions[end-(i-1):end]
                multipliers[i] = n
                i += 1
                valid = true
                break
            end
        end
        if !valid
            multipliers[i] = 0
            i -= 1
            multipliers[i] += 1
        end
    end
    A = sum(multipliers .* exponents)
    display(A)
    @assert run(A, B, C, instructions) == join(instructions, ',')
end