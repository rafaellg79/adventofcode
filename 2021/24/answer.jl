using DelimitedFiles

program = readdlm("input")

A = []
for i = 1:18:size(program, 1)
    push!(A, program[i+4, 3], program[i+5, 3], program[i+15, 3])
end

A = reshape(A, 3, :)
B = []

let max_model_number = zeros(Int, 14), min_model_number = zeros(Int, 14)
    for i = 1:size(A, 2)
        if A[1, i] == 1
            push!(B, i)
        else
            j = pop!(B)
            n = A[3, j]
            m = A[2, i]
            d = n+m
            if d > 0
                max_model_number[j] = 9-d
                max_model_number[i] = 9
                min_model_number[j] = 1
                min_model_number[i] = 1+d
            else
                max_model_number[j] = 9
                max_model_number[i] = 9+d
                min_model_number[j] = 1-d
                min_model_number[i] = 1
            end
        end
    end

    display(join(max_model_number))
    display(join(min_model_number))
end

#=
# Simulation code

instructions = Dict{String, Function}()
instructions["inp"] = (input, n, state) -> state[2][input]=state[1][n]
instructions["add"] = (a, b, state) -> state[2][a]+=b
instructions["mul"] = (a, b, state) -> state[2][a]*=b
instructions["div"] = (a, b, state) -> state[2][a]÷=b
instructions["mod"] = (a, b, state) -> state[2][a]%=b
instructions["eql"] = (a, b, state) -> state[2][a]=Int(state[2][a]==b)

function is_valid(program, model_number::Vector{Int})
    registers = Dict{String, Int}("w"=>0, "x"=>0, "y"=>0, "z"=>0)
    state = (model_number, registers)
    n = 0
    for i = 1:size(program, 1)
        instruction = program[i, 1]
        a = program[i, 2]
        b = program[i, 3]
        if haskey(registers, b)
            b = registers[b]
        end
        if instruction == "inp"
            n += 1
            b = n
        end
        instructions[instruction](a, b, state)
    end
    
    return registers["z"]==0
end

is_valid(program, model_number::Int) = is_valid(program, digits(model_number; pad=14)[end:-1:1])
=#