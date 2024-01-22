# Part 1

function find_first_digit(str)
    for c in str
        if isdigit(c)
            digit = c-'0'
            return digit
        end
    end
end

function find_first_and_last_digits(str)
    return 10 * find_first_digit(str) + find_first_digit(reverse(str))
end

display(sum(find_first_and_last_digits, eachline("input")))

# Part 2

const numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
const numbers_dict = Dict((numbers .=> 1:9)..., (reverse.(numbers) .=> 1:9)..., (string.(1:9) .=> 1:9)...)

function find_first_number(str)
    r = match(r"one|two|three|four|five|six|seven|eight|nine|[1-9]", str)
    return numbers_dict[r.match]
end

function find_first_reverse_number(str)
    r = match(r"enin|thgie|neves|xis|evif|ruof|eerht|owt|eno|[1-9]", str)
    return numbers_dict[r.match]
end

function find_first_and_last_numbers(str)
    return 10 * find_first_number(str) + find_first_reverse_number(reverse(str))
end

display(sum(find_first_and_last_numbers, eachline("input")))