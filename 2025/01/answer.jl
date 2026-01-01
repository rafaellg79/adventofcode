# Part 1

let dial = 50, 
    n = 0

for line in eachline("input")
    s = (line[1] == 'R') ? 1 : -1
    m = parse.(Int, line[2:end])
    dial = mod(dial+s*m, 0:99)
    n += dial == 0
end

display(n)

end

# Part 2

let dial = 50,
    n = 0

for line in eachline("input")
    s = (line[1] == 'R') ? 1 : -1
    m = parse.(Int, line[2:end])
    next_dial = dial+s*m
    if next_dial == 0
        n += 1
    elseif next_dial > 0
        n += div(next_dial, 100)
    else
        n += div(abs(next_dial), 100)+sign(dial)
    end
    dial = mod(next_dial, 0:99)
end

display(n)

end