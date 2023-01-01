using Scanf

let input = readlines("input")
    robots = Int8[1; 0; 0; 0]
    blueprints = Vector{Matrix{Int8}}(undef, 0)
    
    function simulate(robots::Vector{Int8}, blueprint::Matrix{Int8}, ores::Vector{Int16}; sols::Dict{UInt, Tuple{Int16, Int8}}=Dict{UInt, Tuple{Int16, Int8}}(), t=1, time_limit=24, best=0, max_blueprint=maximum.(eachcol(blueprint[:,1:end-1])))
        @views key = hash((min.(robots[1:end-1], max_blueprint), min.(ores[1:end-1], max_blueprint .* (time_limit - t)), robots[end], ores[end]))
        if haskey(sols, key)
            if sols[key][2] <= t
                return sols[key][1]
            end
        end
        if t > time_limit
            sols[key] = (ores[end], t)
            return ores[end]
        end
        if ores[end] + robots[end] * (time_limit-t+1) + div((time_limit-t+1) * (time_limit-t+2), 2) < best
            return best
        end
        
        ores .+= robots
        built_all_robots = true
        for i = 1:size(blueprint, 1)
            if all(blueprint[i, j] <= (ores[j] - robots[j]) for j = 1:length(ores)) && blueprint[i, i] < (time_limit-t)
                robots[i] += 1
                ores .-= @view blueprint[i, :]
                best = max(best, simulate(robots, blueprint, ores; sols=sols, t=t+1, time_limit=time_limit, best=best, max_blueprint=max_blueprint))
                ores .+= @view blueprint[i, :]
                robots[i] -= 1
            else
                built_all_robots = false
            end
        end
        if !built_all_robots
            best = max(best, simulate(robots, blueprint, ores; sols=sols, t=t+1, time_limit=time_limit, best=best, max_blueprint=max_blueprint))
        end
        ores .-= robots
        
        sols[key] = (best, t)
        return best
    end
    
    for line in input
        _, i, ore_cost, clay_cost, obsidian_ore_cost, obsidian_clay_cost, geode_ore_cost, geode_obsidian_cost = 
        @scanf line "Blueprint %i: Each ore robot costs %i ore. Each clay robot costs %i ore. Each obsidian robot costs %i ore and %i clay. Each geode robot costs %i ore and %i obsidian." Int Int Int Int Int Int Int
        push!(blueprints, 
        Int8[ore_cost 0 0 0;
         clay_cost 0 0 0;
         obsidian_ore_cost obsidian_clay_cost 0 0;
         geode_ore_cost 0 geode_obsidian_cost 0;])
    end
    
    # Part 1
    quality_level = 0
    for (i, blueprint) in enumerate(blueprints)
        quality_level += i * simulate(robots, blueprint, zeros(Int16, 4))
    end
    display(quality_level)
    
    # Part 2
    n = 1
    for blueprint in blueprints[1:3]
        n *= simulate(robots, blueprint, zeros(Int16, 4); time_limit=32)
    end
    display(n)
end