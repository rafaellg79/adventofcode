function find_numbers_in_line(line)
    [range(;start=number.offset, length=length(number.match)) for number in eachmatch(r"[0-9]+", line)]
end

# Part 1

let lines = readlines("input")
    part_numbers_sum = 0
    symbols = findall.(character -> !isdigit(character) && character != '.', lines)
    numbers = find_numbers_in_line.(lines)
    for i in eachindex(symbols), j in symbols[i]
        for k = max(i-1, 1):min(i+1, length(symbols))
            part_numbers_sum += sum(parse(Int, lines[k][l]) for l in filter((x) -> !isdisjoint(x, (j-1):(j+1)), numbers[k]); init=0)
        end
    end
    display(part_numbers_sum)
end

# Part 2

let lines = readlines("input")
    gear_ratios_sum = 0
    symbols = findall.(==('*'), lines)
    numbers = find_numbers_in_line.(lines)
    for i in eachindex(symbols), j in symbols[i]
        part_numbers = Int[]
        for k = max(i-1, 1):min(i+1, length(symbols))
            append!(part_numbers, parse(Int, lines[k][l]) for l in filter((x) -> !isdisjoint(x, (j-1):(j+1)), numbers[k]))
        end
        if length(part_numbers) == 2
            gear_ratios_sum += prod(part_numbers)
        end
    end
    display(gear_ratios_sum)
end