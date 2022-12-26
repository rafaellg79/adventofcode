let input = readlines("input")
    
    get_priority = (c) -> return (c == lowercase(c)) ? c-'a'+1 : c-'A'+27
    
    # Part 1
    let priorities_sum = 0
        for line in input
            half = length(line)÷2
            first_compartment = Set(line[1:half])
            second_compartment = Set(line[half+1:end])
            common = first(intersect(first_compartment, second_compartment))
            priorities_sum += get_priority(common)
        end
        display(priorities_sum)
    end
    
    # Part 2
    let priorities_sum = 0
        for i = 1:3:length(input)
            first_rucksack = Set(input[i])
            second_rucksack = Set(input[i+1])
            third_rucksack = Set(input[i+2])
            common = first(intersect(first_rucksack, second_rucksack, third_rucksack))
            priorities_sum += get_priority(common)
        end
        display(priorities_sum)
    end
end