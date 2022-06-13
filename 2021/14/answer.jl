using DelimitedFiles

template, rules = open("input") do file
    template = readline(file)
    rules = readdlm(file)
    return template, Dict{String, Char}(rules[:, 1] .=> only.(rules[:, 3]))
end

let polymer = template
    elements_occurences = Dict{Char, Int}('A':'Z' .=> 0)
    adjacent_pairs_current = Dict{String, Int}(keys(rules) .=> 0)
    adjacent_pairs_next = Dict{String, Int}(keys(rules) .=> 0)
    
    foreach(element -> elements_occurences[element]+=1, polymer)
    
    for i = 1:length(polymer)-1
        adjacent_pairs_current[polymer[i:i+1]] += 1
    end
    
    for i = 1:40
        for (pair, pair_occurences) in adjacent_pairs_current
            inserted_element = rules[pair]
            elements_occurences[inserted_element] += pair_occurences
            adjacent_pairs_next[string(first(pair), inserted_element)] += pair_occurences
            adjacent_pairs_next[string(inserted_element, last(pair))] += pair_occurences
        end
        adjacent_pairs_current = adjacent_pairs_next
        adjacent_pairs_next = Dict{String, Int}(keys(rules) .=> 0)
        
        if i == 10
            non_zero_occurrences = filter(!iszero, collect(values(elements_occurences)))
            least, most = extrema(non_zero_occurrences)
            display(most - least)
        end
    end
    
    non_zero_occurrences = filter(!iszero, collect(values(elements_occurences)))
    least, most = extrema(non_zero_occurrences)
    display(most - least)
end
