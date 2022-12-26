let input = readlines("input")
    number_to_snafu = Dict('=' => -2, '-' => -1, '0' => 0, '1' => 1, '2' => 2)
    snafu_to_number = Dict(values(number_to_snafu) .=> keys(number_to_snafu))
    
    decimal = 0
    for line in input
        n = 0
        for (i, c) in enumerate(reverse(line))
            n += number_to_snafu[c] * (5 ^ (i-1))
        end
        decimal += n
    end
    
    snafu = ""
    while decimal != 0
        i = mod(decimal, -2:2)
        decimal = div(decimal, 5) + (i < 0)
        snafu = snafu_to_number[i] * snafu
    end
    
    display(snafu)
end