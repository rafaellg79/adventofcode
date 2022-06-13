lines = map(collect, readlines("input"))
digits_matrix = hcat(lines...)

half = size(digits_matrix, 2) / 2
number_of_ones = count(==('1'), digits_matrix, dims=[2])
most_common = join(total_ones >= half ? 1 : 0 for total_ones in number_of_ones)

gamma = parse(UInt, most_common, base=2)
pad = sizeof(gamma) * 8 - length(number_of_ones)
epsilon = (~gamma << pad) >> pad

O2  = collect(1:length(lines))
CO2 = copy(O2)

for (cmp, list) in [(>=, O2), (<, CO2)]
    for i = 1:size(digits_matrix, 1)
        if length(list) == 1
            break
        end
        selected_numbers = @view selectdim(digits_matrix, 1, i)[list]
        n = cmp(count(==('1'), selected_numbers), (length(list) / 2)) ? '1' : '0'
        filter!(j -> digits_matrix[i, j]==n, list)
    end
end

O2  = parse(Int, join(lines[O2[1]]), base=2)
CO2 = parse(Int, join(lines[CO2[1]]), base=2)

display(Int(gamma * epsilon))
display(O2 * CO2)