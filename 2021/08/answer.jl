using DelimitedFiles

entries = strip.(readdlm("input", '|', String))

patterns = hcat(split.(entries[:, 1], ' ')...)
output = hcat(split.(entries[:, 2], ' ')...)

function is_unique(signal)
    n = length(signal)
    return n==2 || n == 3 || n == 4 || n == 7
end

display(count(char -> is_unique(char), output))

function to_set(str::String)
    return Set{Char}(collect(str))
end

patterns_sets = map(pattern->Set{Char}([pattern...]), patterns)
numbers = Dict{Set{Char}, Int}(zip(to_set.(["abcefg" "cf" "acdeg" "acdfg" "bcdf" "abdfg" "abdefg" "acf" "abcdefg" "abcdfg"]), 0:9))
decoded_output = zeros(Int, size(output))

function find_mapping(patterns::Vector{Set{Char}})
    decode_map = Dict{Char, Char}()
    set_map = Dict{Int, Int}(1 => 1, 7 => 2, 4 => 3, 8 => 10)
    sorted_patterns = sort(patterns; lt=(x, y) -> length(x)<length(y))
    
    for i = 7:9
        if length(intersect(sorted_patterns[set_map[1]], sorted_patterns[i])) == 1
            set_map[6] = i
        elseif length(intersect(sorted_patterns[set_map[4]], sorted_patterns[i])) == 4
            set_map[9] = i
        else
            set_map[0] = i
        end
    end
    
    for i = 4:6
        if length(intersect(sorted_patterns[set_map[1]], sorted_patterns[i])) == 2
            set_map[3] = i
        elseif length(intersect(sorted_patterns[set_map[4]], sorted_patterns[i])) == 2
            set_map[2] = i
        else
            set_map[5] = i
        end
    end
    
    decode_map[first(setdiff(sorted_patterns[set_map[7]], sorted_patterns[set_map[1]]))] = 'a'
    decode_map[first(setdiff(sorted_patterns[set_map[4]], sorted_patterns[set_map[3]]))] = 'b'
    decode_map[first(setdiff(sorted_patterns[set_map[8]], sorted_patterns[set_map[6]]))] = 'c'
    decode_map[first(setdiff(sorted_patterns[set_map[8]], sorted_patterns[set_map[0]]))] = 'd'
    decode_map[first(setdiff(sorted_patterns[set_map[8]], sorted_patterns[set_map[9]]))] = 'e'
    decode_map[first(setdiff(sorted_patterns[set_map[3]], sorted_patterns[set_map[2]]))] = 'f'
    decode_map[first(setdiff(sorted_patterns[set_map[8]], keys(decode_map)))] = 'g'
    
    return decode_map
end

for i = 1:size(patterns_sets, 2)
    decode_map = find_mapping(patterns_sets[:, i])
    decode = (segment) -> decode_map[segment]

    decoded_output[:, i] = map(x -> numbers[Set{Char}(x)], map(x -> decode.(collect(x)), output[:, i]))
end

to_int = (digits; base=10) -> sum(digits[end-k+1]*base^(k-1) for k=1:length(digits))
display(sum(mapslices(to_int, decoded_output; dims=[1])))