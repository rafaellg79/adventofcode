# Part 1

A = Int[]
B = Int[]
for line in eachline("input")
    a, b = parse.(Int, split(line))
    push!(A, a)
    push!(B, b)
end

sort!(A)
sort!(B)

display(sum(abs, B.-A))

# Part 2

begin 
global s = 0

for e in A
    b = count(==(e), B)
    global s += e*b
end
display(s)

end