using DelimitedFiles, Statistics

positions = readdlm("input", ',', Int)

dist = (x, y) -> abs(x - y)
cost = (A, center, dist) -> sum(x -> dist(x, center), A)

align_pos = Int(median(positions))
display(cost(positions, align_pos, dist))

dist = (x, y) -> div(abs(x - y) * (abs(x - y)+1), 2)
l, r = extrema(positions)
all_costs = map(pos -> cost(positions, pos, dist), l:r)

display(minimum(all_costs))