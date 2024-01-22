function map_seed(seed, dst, src)
    return (dst-src) .+ seed
end

# Part 1

let lines = readlines("input")
    seeds = parse.(Int, split(lines[1])[2:end])
    maps_start = findall(==(""), lines)
    push!(maps_start, length(lines)+1)
    mapped = falses(length(seeds))
    for i = eachindex(@view maps_start[1:end-1])
        mapped .= false
        farm_map = @view lines[(maps_start[i]+2):(maps_start[i+1]-1)]
        for n = eachindex(farm_map)
            dst, src, r = parse.(Int, split(farm_map[n]))
            for m in eachindex(seeds)
                if mapped[m] == false && src <= seeds[m] < (src + r)
                    mapped[m] = true
                    seeds[m] = map_seed(seeds[m], dst, src)
                end
            end
        end
    end
    display(minimum(seeds))
end

# Part 2

let lines = readlines("input")
    score = typemax(Int)
    maps_start = findall(==(""), lines)
    
    # Memory upperbound increases EXPONENTIALLY with the number of maps, be sure the input has few maps
    seeds = Vector{UnitRange}(undef, 3^length(maps_start) * count(isspace, first(lines)))
    mapped = falses(length(seeds))

    initial_seeds = parse.(Int, split(lines[1])[2:end])
    num_active_seeds = div(length(initial_seeds), 2)
    seeds[1:num_active_seeds] .= UnitRange[(initial_seeds[i]: (initial_seeds[i] + initial_seeds[i+1])) for i = 1:2:length(initial_seeds)]
    push!(maps_start, lastindex(lines)+1)
    for i = eachindex(@view maps_start[1:end-1])
        mapped[1:num_active_seeds] .= false
        farm_map = @view lines[(maps_start[i]+2):(maps_start[i+1]-1)]
        for n = eachindex(farm_map)
            first_space = findfirst(isspace, farm_map[n])
            last_space = findlast(isspace, farm_map[n])
            
            dst = parse(Int, (@view farm_map[n][1:first_space]))
            src = parse(Int, (@view farm_map[n][first_space:last_space]))
            r = parse(Int, (@view farm_map[n][last_space:end]))
            for m in 1:num_active_seeds
                seed = seeds[m]
                if mapped[m] == false
                    mapped_range = intersect(src:src + r-1, seed)
                    if isempty(mapped_range)
                        continue
                    end
                    if first(seed) < first(mapped_range)
                        seeds[m] = first(seed):first(mapped_range)-1
                    end
                    if last(mapped_range) < last(seed)
                        if first(seed) < first(mapped_range)
                            num_active_seeds += 1
                            seeds[num_active_seeds] = last(mapped_range)+1:last(seed)
                        else
                            seeds[m] = last(mapped_range)+1:last(seed)
                        end
                    end
                    if mapped_range == seed
                        mapped[m] = true
                        seeds[m] = map_seed(seed, dst, src)
                    else
                        num_active_seeds += 1
                        mapped[num_active_seeds] = true
                        seeds[num_active_seeds] = map_seed(mapped_range, dst, src)
                    end
                end
            end
        end
    end
    display(minimum(first, @view seeds[1:num_active_seeds]))
end