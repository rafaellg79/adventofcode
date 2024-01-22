const total_cubes = Dict("red" => 12, "green" => 13, "blue" => 14)

function valid_cube(cube)
    num, color = split(cube, " ")
    return total_cubes[color] >= parse(Int, num)
end

# Part 1

let lines = readlines("input")
    IDs_sum = sum(enumerate(lines)) do (i, line)
        for subset in eachsplit(line[findfirst(":", line)[1]+2:end], "; ")
            if any(!valid_cube, eachsplit(subset, ", "))
                return zero(i)
            end
        end
        return i
    end
    display(IDs_sum)
end

# Part 2

let lines = readlines("input")
    power_sum = sum(enumerate(lines)) do (i, line)
        min_cubes = Dict("red" => 0, "green" => 0, "blue" => 0)
        for subset in eachsplit(line[findfirst(":", line)[1]+2:end], "; ")
            for cube in eachsplit(subset, ", ")
                num, color = split(cube, " ")
                min_cubes[color] = max(min_cubes[color], parse(Int, num))
            end
        end
        prod(values(min_cubes))
    end
    display(power_sum)
end