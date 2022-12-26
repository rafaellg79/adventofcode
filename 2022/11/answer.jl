using Scanf

let input = readlines("input")
    struct Monkey
        items::Vector{Int}
        operation::Function
        test::Function
    end
    
    op_dict = Dict{String, Function}("+" => +, "*" => *)
    common_multiplier = 1 # For part 2

    M = Monkey[]
    for i = 1:7:length(input)
        instructions = strip.(input[i:i+5])
        # parse
        items = parse.(Int, split(last(split(instructions[2], ": ")), ", "))
        _, op, c = @scanf instructions[3] "Operation: new = old %s %s" String String
        c = tryparse(Int, c)
        if !isnothing(c)
            operation = (old) -> op_dict[op](old, c)
        else
            operation = (old) -> op_dict[op](old, old)
        end
        _, n = @scanf instructions[4] "Test: divisible by %i" Int
        _, t = @scanf instructions[5] "If true: throw to monkey %i" Int
        _, f = @scanf instructions[6] "If false: throw to monkey %i" Int
        common_multiplier *= n # This is actually the least common multiplier because all test divisors are distinct primes (at least in my input)
        test = (m) -> ((m % n) == 0) ? (t+1) : (f+1)
        push!(M, Monkey(items, operation, test))
    end

    # Part 1
    let monkeys = deepcopy(M)
        inspections = zeros(Int, length(monkeys))
        for _ = 1:20
            for (i, monkey) in enumerate(monkeys)
                while !isempty(monkey.items)
                    inspections[i] += 1
                    item = popfirst!(monkey.items)
                    item = monkey.operation(item)
                    item = div(item, 3)
                    push!(monkeys[monkey.test(item)].items, item)
                end
            end
        end
    
        display(prod(sort(inspections)[end-1:end]))
    end

    # Part 2
    let monkeys = deepcopy(M)
        inspections = zeros(Int, length(monkeys))
        for _ = 1:10000
            for (i, monkey) in enumerate(monkeys)
                while !isempty(monkey.items)
                    inspections[i] += 1
                    item = popfirst!(monkey.items)
                    item = monkey.operation(item)
                    push!(monkeys[monkey.test(item)].items, item % common_multiplier)
                end
            end
        end
    
        display(prod(sort(inspections)[end-1:end]))
    end
end