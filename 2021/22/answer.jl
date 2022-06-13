using DelimitedFiles

steps = readdlm("input", ' ')

instructions = steps[:, 1].=="on"
cuboids = map(steps[:, 2]) do cuboid
    edges = split(cuboid, ',')
    edges = map(s->s[3:end], edges)
    edges = parse.(Int, hcat(split.(edges, "..")...))
    edges = [edges[1, i]:edges[2, i] for i = 1:3]
    return edges
end

grid = falses(101, 101, 101)
offset = [51 51 51]

for (instruction, cuboid) in zip(instructions, cuboids)
    ranges = [intersect(cuboid[i].+offset[i], 1:size(grid, i)) for i = 1:3]
    grid[ranges...] .= instruction
end

display(count(grid))

function remove_cuboid(cuboid1, cuboid2)
    intersect_ranges = [intersect(cuboid1[i], cuboid2[i]) for i = 1:3]
    if any(isempty, intersect_ranges)
        return [cuboid1]
    else
        l = [first(cuboid1[i]):(first(cuboid2[i])-1) for i = 1:3]
        r = [(last(cuboid2[i])+1):last(cuboid1[i]) for i = 1:3]
        
        x = [[l[1], cuboid1[2], cuboid1[3]], [r[1], cuboid1[2], cuboid1[3]]]
        y = [[intersect_ranges[1], l[2], cuboid1[3]], [intersect_ranges[1], r[2], cuboid1[3]]]
        z = [[intersect_ranges[1], intersect_ranges[2], l[3]], [intersect_ranges[1], intersect_ranges[2], r[3]]]
        
        return filter(range->all(!isempty, range), union(x, y, z))
    end
end

function volume(cuboid)
    prod(length, cuboid)
end

let ranges = []
    for i = 1:length(instructions)
        instruction = instructions[i]
        cuboid = cuboids[i]
        j = 1
        while j <= length(ranges)
            previous_cuboid = ranges[j]
            new_cuboids = remove_cuboid(previous_cuboid, cuboid)
            if !(previous_cuboid in new_cuboids)
                append!(deleteat!(ranges, j), new_cuboids)
            else
                j+=1
            end
        end
        if instruction
            push!(ranges, cuboid)
        end
    end
    
    display(sum(volume, ranges))
end
