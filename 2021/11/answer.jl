energies = parse.(Int, hcat(collect.(readlines("input"))...))

kernel = vec([CartesianIndex(x, y) for x in [-1, 0, 1], y in [-1, 0, 1]])
deleteat!(kernel, 5)

function flash!(energies::Matrix{Int}, pos::CartesianIndex)
    neighbors = map((neighbor) -> pos + neighbor, kernel)
    for neighbor in neighbors
        if checkbounds(Bool, energies, neighbor)
            energies[neighbor] += 1
            if energies[neighbor] == 10
                flash!(energies, neighbor)
            end
        end
    end
end

function step!(energies)
    energies .+= 1
    flash!.(Ref(energies), filter(i -> energies[i]==10, CartesianIndices(energies)))
    
    flashes = 0
    map!(energies, energies) do energy
        if energy >= 10
            flashes += 1
            return 0
        end
        energy
    end
    return flashes
end

energies_0 = copy(energies)

display(sum(x -> step!(energies), 1:100))

energies .= energies_0

n=1

while step!(energies) < length(energies)
    global n += 1
end

display(n)