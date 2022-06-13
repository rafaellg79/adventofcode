using DelimitedFiles

function children(first_birth, last_day, cycle)
    return 1 + (last_day - first_birth - 1) ÷ (cycle + 1)
end

function descendants(last_day, cycle, first_cycle)
    d = zeros(Int, last_day)
    d[end] = 0
    for i = last_day:-1:1
        d[i] += children(i, last_day, cycle)
        for j = i+first_cycle+1:cycle+1:last_day-1
            d[i] += d[j]
        end
    end
    return d
end

ages = readdlm("input", ',', Int)

d = descendants(80, 6, 8)
display(sum(age -> d[age]+1, ages)) # add 1 to count self
d = descendants(256, 6, 8)
display(sum(age -> d[age]+1, ages)) # add 1 to count self