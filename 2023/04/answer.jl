function parse_card_numbers(card)
    prev_is_digit = false
    winning_numbers = Set{Int}()
    my_numbers = Set{Int}()
    number = 0
    array = winning_numbers
    for character in card[findfirst(':', card)+1 : end]
        if isdigit(character)
            number = number * 10 + Int(character - '0')
        elseif !iszero(number)
            push!(array, number)
            number = 0
        end
        if character == '|'
            number = 0
            array = my_numbers
        end
    end
    push!(my_numbers, number)
    return winning_numbers, my_numbers
end

# Part 1

let lines = readlines("input")
    points = sum(lines) do line
        winning_numbers, my_numbers = parse_card_numbers(line)
        intersect!(winning_numbers, winning_numbers, my_numbers)
        if !isempty(winning_numbers)
            return 1 << (length(winning_numbers) - 1)
        end
        return 0
    end
    display(points)
end

# Part 2

let lines = readlines("input")
    card_instances = ones(Int, length(lines))
    for (i, line) in enumerate(lines)
        winning_numbers, my_numbers = parse_card_numbers(line)
        intersect!(winning_numbers, winning_numbers, my_numbers)
        card_instances[i+1:i+length(winning_numbers)] .+= card_instances[i]
    end
    display(sum(card_instances))
end