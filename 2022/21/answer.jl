let input = readlines("input")
    # Part 1
    monkeys = Dict()
    ops = Dict("+" => +, "-" => -, "*" => *, "/" => div)
    for line in input
        name, op = strip.(split(line, ":"))
        value = tryparse(Int, op)
        if isnothing(value)
            a, op_name, b = split(op)
            op = () -> ops[op_name](typeof(monkeys[a])==Int ? monkeys[a] : monkeys[a](), typeof(monkeys[b])==Int ? monkeys[b] : monkeys[b]())
            monkeys[name] = op
        else
            monkeys[name] = value
        end
    end
    display(monkeys["root"]())
    
    # Part 2
    Base.:+(a::Vector{T}, b::T) where T = [a[1]+b; a[2]]
    Base.:+(a::T, b::Vector{T}) where T = [b[1]+a; b[2]]
    Base.:-(a::Vector{T}, b::T) where T = [a[1]-b; a[2]]
    Base.:-(a::T, b::Vector{T}) where T = [a-b[1]; -b[2]]
    Base.:*(a::Vector{T}, b::T) where T<:Rational = a.*b
    Base.:*(a::T, b::Vector{T}) where T<:Rational = a.*b
    Base.:/(a::Vector{T}, b::T) where T<:Rational = a./b
    Base.:/(a::T, b::Vector{T}) where T<:Rational = a./b
    
    monkeys = Dict()
    ops = Dict("+" => +, "-" => -, "*" => *, "/" => /)
    for line in input
        name, op = strip.(split(line, ":"))
        value = tryparse(Int, op)
        if name == "humn"
            monkeys[name] = () -> Rational[0; 1]
        else
            if isnothing(value)
                a, op_name, b = split(op)
                op = () -> begin
                    a = monkeys[a]
                    b = monkeys[b]
                    a = typeof(a) <: Function ? a() : a
                    b = typeof(b) <: Function ? b() : b
                    if name == "root"
                        if typeof(a) <: Array
                            return (b-a[1])/a[2]
                        elseif typeof(b) <: Array
                            return (a-b[1])/b[2]
                        end
                    else
                        return ops[op_name](a, b)
                    end
                end
                monkeys[name] = op
            else
                monkeys[name] = Rational(value)
            end
        end
    end
    display(monkeys["root"]())
end