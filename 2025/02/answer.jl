# Part 1

let input = readline("input")
    ids = split(input, ',')
    n = 0

    for id in ids
        min, max = split(id, '-')
        range = parse(Int, min):parse(Int, max)
        for m in range
            m_str = "$m"
            if isodd(length(m_str))
                continue
            end
            valid = false
            l = div(length(m_str), 2)
            for i in 1:l
                if m_str[i] != m_str[i+l]
                    valid = true
                    break
                end
            end
            if !valid
                n += m
            end
        end
    end

    display(n)
end

# Part 2

# Ideally we should just iterate over the divisors of the length of digits, the number of invalids would be the max - min +1 of that number of digits.
# For example, if we have a range of 4000 to 9999 then, we iterate over single digits that is 4 to 9, so 9-4+1 = 6 (4444, 5555,... 9999) should be in it, then 2 digits, 99-44+1 = 46 (4444,4545,... 9898, 9999), 3 digits isn't a divisor of 4, so we skip it.
# The problem with that strategy is counting repeated numbers (4444) and edge cases, such as 4445 to 9000 for example.
# I was a bit bummed that there were only 12 days and no leaderboard, so I didn't implement it, but I might revisit this problem (as well as others) and implement it.

let input = readline("input")
    ids = split(input, ',')
    n = 0

    for id in ids
        min, max = split(id, '-')
        range = parse(Int, min):parse(Int, max)
        for m in range
            m_str = "$m"
            valid = true
            l = length(m_str)
            for divisor in 2:l
                if l % divisor != 0
                    continue
                end
                s = div(l, divisor)
                if all(all(==(m_str[i]), m_str[i:s:l]) for i in 1:s)
                    valid = false
                    break
                end
            end
            if !valid
                n += m
            end
        end
    end

    display(n)
end