const dirs = [CartesianIndex(-1,0), CartesianIndex(0,1), CartesianIndex(1,0), CartesianIndex(0,-1)]
const dirs_symbol = ['^', '>', 'v', '<']

function generate_paths(keypad)
    paths = Dict{Tuple, Vector{String}}()
    for src in CartesianIndices(keypad), dst in CartesianIndices(keypad)
        if keypad[src] == ' ' || keypad[dst] == ' '
            continue
        end
        paths[(keypad[src], keypad[dst])] = String[]
        next = [(src, "")]
        path = ""
        while !isempty(next)
            current, path = popfirst!(next)
            if current == dst
                push!(paths[(keypad[src], keypad[dst])], path*'A')
                continue
            end
            iter = filter(x -> sum((dst-current).I.*x[1].I)>0, collect(zip(dirs, dirs_symbol)))
            for (dir, c) in iter
                i=0
                while sum((dst-(current+(i+1)*dir)).I.*dir.I)>=0 && keypad[current+(i+1)*dir] != ' '
                    i+=1
                end
                if i > 0
                    push!(next, (current+i*dir, path * c^i))
                end
            end
        end
    end
    return paths
end

const numeric_keypad_instructions = generate_paths(
         ['7' '8' '9';
          '4' '5' '6';
          '1' '2' '3';
          ' ' '0' 'A';])
const directional_keypad_instructions = generate_paths(
         [' ' '^' 'A';
          '<' 'v' '>';])
const paths = merge(numeric_keypad_instructions, directional_keypad_instructions)

function smallest(src, dst, n; sols=Dict())
    if haskey(sols, (src, dst, n))
        return sols[(src, dst, n)]
    end
    if n == 1
        sols[(src, dst, n)] = length(paths[(src, dst)][1])
        return length(paths[(src, dst)][1])
    end
    sol = typemax(Int)
    for path in paths[(src, dst)]
        temp = 'A'*path
        temp_sol = 0
        for i in 1:length(temp)-1
            temp_sol += smallest(temp[i], temp[i+1], n-1; sols=sols)
        end
        sol = min(sol, temp_sol)
    end
    sols[(src, dst, n)] = sol
    return sol
end

function smallest(sequence, n)
    sol = 0
    temp = 'A'*sequence
    for i in 1:length(temp)-1
        sol += smallest(temp[i], temp[i+1], n)
    end
    return sol
end

# Part 1

let lines = readlines("input")
    s = 0
    for line in lines
        s += (smallest(line, 3)) * parse(Int, line[1:end-1])
    end
    display(s)
end

# Part 2

let lines = readlines("input")
    s = 0
    for line in lines
        s += (smallest(line, 26)) * parse(Int, line[1:end-1])
    end
    display(s)
end