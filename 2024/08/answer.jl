# Part 1

let lines = readlines("input")
    antennas = Dict{Char, Vector{CartesianIndex{2}}}()
    for i in 1:length(lines)
        for j in 1:length(lines[i])
            antenna = lines[i][j]
            if antenna != '.'
                if !haskey(antennas, antenna)
                    antennas[antenna] = CartesianIndex[]
                end
                push!(antennas[antenna], CartesianIndex(i, j))
            end
        end
    end
    
    antinodes = Set{CartesianIndex{2}}()
    
    for coordinates in values(antennas)
        for I in coordinates, J in coordinates
            if I == J
                continue
            else
                delta = I-J
                if 0 < (I + delta)[1] <= length(lines[1]) && 0 < (I + delta)[2] <= length(lines)
                    push!(antinodes, I + delta)
                end
                if 0 < (J - delta)[1] <= length(lines[1]) && 0 < (J - delta)[2] <= length(lines)
                    push!(antinodes, J - delta)
                end
            end
        end
    end
    
    display(length(antinodes))
end

# Part 2

let lines = readlines("input")
    antennas = Dict{Char, Vector{CartesianIndex{2}}}()
    for i in 1:length(lines)
        for j in 1:length(lines[i])
            antenna = lines[i][j]
            if antenna != '.'
                if !haskey(antennas, antenna)
                    antennas[antenna] = CartesianIndex[]
                end
                push!(antennas[antenna], CartesianIndex(i, j))
            end
        end
    end
    
    antinodes = Set{CartesianIndex{2}}()
    
    for coordinates in values(antennas)
        for I in coordinates, J in coordinates
            if I == J
                continue
            else
                delta = I-J
                n = 0
                while 0 < (I + n*delta)[1] <= length(lines[1]) && 0 < (I + n*delta)[2] <= length(lines)
                    push!(antinodes, I + n*delta)
                    n+=1
                end
                n = 0
                while 0 < (J - n*delta)[1] <= length(lines[1]) && 0 < (J - n*delta)[2] <= length(lines)
                    push!(antinodes, J - n*delta)
                    n+=1
                end
            end
        end
    end
    
    display(length(antinodes))
end