using DelimitedFiles

a = readdlm("input", Int)

count_increases = (A, offset=1) -> count(x < y for (x, y) in zip(A, A[1+offset:end]))
increases = count_increases(a)
increases_windowed = count_increases(a, 3)

display(increases)
display(increases_windowed)