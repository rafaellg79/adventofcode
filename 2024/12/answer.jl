const dirs = [CartesianIndex(-1, 0), CartesianIndex(0, -1), CartesianIndex(1, 0), CartesianIndex(0, 1)]

# Part 1

let lines = readlines("input")
    plots = permutedims(hcat(collect.(lines)...))
    plants = Set(plots)
    price = 0
    visited = falses(size(plots))
    for I in CartesianIndices(plots)
        next = [I]
        plant = plots[I]
        area = 0
        perimeter = 0
        while !isempty(next)
            I = pop!(next)
            if visited[I]
                continue
            else
                visited[I] = true
            end
            area += 1
            for dir in dirs
                if get(plots, I+dir, ' ') == plant
                    push!(next, I+dir)
                else
                    perimeter += 1
                end
            end
        end
        price += area * perimeter
    end
    
    display(price)
end

# Part 2

let lines = readlines("input")
    plots = permutedims(hcat(collect.(lines)...))
    plants = Set(plots)
    price = 0
    visited = falses(size(plots))
    for I in CartesianIndices(plots)
        next = [I]
        plant = plots[I]
        area = 0
        sides = 0
        while !isempty(next)
            I = pop!(next)
            if visited[I]
                continue
            end
            visited[I] = true
            area += 1
            for (i, dir) in enumerate(dirs)
                perp = CartesianIndex(-dir[2], dir[1])
                if get(plots, I+dir, ' ') == plant
                    push!(next, I+dir)
                end
                if get(plots, I+dir, ' ') == plant && get(plots, I+perp, ' ') == plant && get(plots, I+dir, ' ') != get(plots, I+dir+perp, ' ')
                    sides+=1
                end
                if get(plots, I+dir, ' ') != plant && get(plots, I+perp, ' ') != plant
                    sides+=1
                end
            end
        end
        price += area * sides
    end
    
    display(price)
end