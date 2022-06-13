lines = readlines("input")

snailfish_numbers = []

function parse_snailfish_number(snailfish_number)
    if snailfish_number[1] == '['
        open_delimiters = 0
        for i in 2:length(snailfish_number)
            c = snailfish_number[i]
            if c == '['
                open_delimiters += 1
            elseif c == ']'
                open_delimiters -= 1
            elseif c == ',' && open_delimiters == 0
                return [parse_snailfish_number(snailfish_number[2:i-1]),
                        parse_snailfish_number(snailfish_number[i+1:end-1])]
            end
        end
    else
        return parse(Int, snailfish_number)
    end
end

function add(a, b)
    return reduction([a, b])
end

function add(a::Array, n::Number)
    return [a[1:end-1]..., add(a[end], n)]
end

function add(n::Number, a::Array)
    return [add(n, a[1]), a[2:end]...]
end

add(a::Number, b::Number) = a+b

function explode(n::Array; depth=0)
    for (i, x) in enumerate(n)
        if isa(x, Array)
            exploded_n, left, right, exploded = explode(x; depth=depth+1)
            if exploded
                if i == 1
                    return [exploded_n, add(right, n[2])], left, 0, exploded
                else
                    return [add(n[1], left), exploded_n], 0, right, exploded
                end
            end
        end
    end
    if depth >= 4
        return 0, n[1], n[2], true
    else
        return n, 0, 0, false
    end
end

function split_snailfish_number(n::Number)
    if n >= 10
        return [fld(n, 2), cld(n, 2)], true
    else
        return n, false
    end
end

function split_snailfish_number(n::Array)
    splitted = false
    for (i, x) in enumerate(n)
        splitted_n, splitted = split_snailfish_number(x)
        if splitted
            if i == 1
                return [splitted_n, n[2]], splitted
            else
                return [n[1], splitted_n], splitted
            end
        end
    end
    return n, false
end

function reduction(n)
    exploded, splitted = false, false
    reduced_n, _, _, exploded = explode(n)
    if !exploded
        reduced_n, splitted = split_snailfish_number(reduced_n)
    end
    if exploded || splitted
        return reduction(reduced_n)
    end
    return n
end

function magnitude(n::Number)
    return n
end

function magnitude(n::Array)
    return 3*magnitude(n[1])+2*magnitude(n[2])
end

for line in lines
    push!(snailfish_numbers, parse_snailfish_number(line))
end

display(magnitude(reduce(add, snailfish_numbers)))

let max_mag = 0
    for i = 1:length(snailfish_numbers), j = 1:length(snailfish_numbers)
        if i != j
            ij = add(snailfish_numbers[i], snailfish_numbers[j])
            max_mag = max(max_mag, magnitude(ij))
        end
    end
    display(max_mag)
end