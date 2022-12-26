let i = readlines("input")
    separators = [1; findall((x) -> x=="", i); length(i)]
    i = map(x-> x=="" ? 0 : parse(Int, x), i)
    
    elf_indices = range.(separators[1:end-1], separators[2:end], step=1)
    total_calories = sum.(x->i[x], elf_indices)
    sort!(total_calories)
    
    # Part 1
    display(total_calories[end])
    # Part 2
    display(sum(total_calories[end-2:end]))
end