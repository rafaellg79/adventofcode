let input = readlines("input")
    lists = eval.(Meta.parse.(input))
    filter!(!isnothing, lists)
    
    function compare(a::Int, b::Int)
        return sign(b - a)
    end
    
    function compare(a::Vector, b::Vector)
        for i in 1:min(length(a), length(b))
            result = compare(a[i], b[i])
            if result != 0
                return result
            end
        end
        return compare(length(a), length(b))
    end
    
    function compare(a::Vector, b::Int)
        compare(a, [b])
    end
    
    function compare(a::Int, b::Vector)
        compare([a], b)
    end
    
    # Part 1
    S = 0
    for i = 1:div(length(lists), 2)
        if compare(lists[2*i-1], lists[2*i]) == 1
            S += i
        end
    end
    display(S)
    
    # Part 2
    sorted_lists = sort(vcat(lists, [[[2]], [[6]]]); lt=(a, b) -> compare(a, b) > 0)
    
    display(findfirst(==([[2]]), sorted_lists) * findfirst(==([[6]]), sorted_lists))
end