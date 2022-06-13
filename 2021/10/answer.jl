open("input") do file

    delimiters_pairs = Dict{Char, Char}('(' => ')', '[' => ']', '{' => '}', '<' => '>')
    points_table = Dict{Char, Int}(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    autocomplete_table = Dict{Char, Int}(')' => 1, ']' => 2, '}' => 3, '>' => 4)

    syntax_score = 0
    autocomplete_scores = Int[]

    while !eof(file)
        line = readline(file)
        open_delimiters = []
        corrupt_line = false
        for delimiter in line
            if haskey(delimiters_pairs, delimiter)
                push!(open_delimiters, delimiter)
            elseif !isempty(open_delimiters) && delimiters_pairs[last(open_delimiters)] == delimiter
                pop!(open_delimiters)
            else
                syntax_score += points_table[delimiter]
                corrupt_line = true
                break
            end
        end
        
        if !corrupt_line && length(open_delimiters) > 0
            get_score = delimiter -> autocomplete_table[delimiters_pairs[delimiter]]
            score = mapfoldl(get_score, (current, next) -> current * 5 + next, Iterators.reverse(open_delimiters))
            push!(autocomplete_scores, score)
        end
    end

    display(syntax_score)
    display(sort(autocomplete_scores)[(1+end)÷2])
end