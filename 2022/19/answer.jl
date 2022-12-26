using Scanf

let input = readlines("input")
    robots = Int8[1; 0; 0; 0]
    blueprints = Vector{Matrix{Int8}}(undef, 0)
    
    function simulate(robots::Vector{Int8}, blueprint::Matrix{Int8}, ores::Vector{Int16}, sols::Dict{Int, Tuple{Int16, Int8}}; t=1, time_limit=24, best=0)
        @assert maximum(ores)<1000 "Too many ores! Hashing function will duplicate keys!"
        key = sum(robots[i+1] * (time_limit^i) for i = 0:3) + sum(ores[i+1] * time_limit^(4+2i) for i = 0:3)
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
        best = max(best, simulate(robots, blueprint, ores, sols; t=t+1, time_limit=time_limit, best=best))
        for i = 1:size(blueprint, 1)
            if all(blueprint[i, j] <= (ores[j] - robots[j]) for j = 1:length(ores)) && blueprint[i, i] < (time_limit-t)
                robots[i] += 1
                ores .-= @view blueprint[i, :]
                best = max(best, 
                                 simulate(robots, blueprint, ores, sols; t=t+1, time_limit=time_limit, best=best))
                ores .+= @view blueprint[i, :]
                robots[i] -= 1
            end
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
        sols = Dict{Int, Tuple{Int16, Int8}}()
        quality_level += i * simulate(robots, blueprint, zeros(Int16, 4), sols)
    end
    display(quality_level)
    
    # Part 2
    n = 1
    for blueprint in blueprints[1:3]
        sols = Dict{Int, Tuple{Int16, Int8}}()
        n *= simulate(robots, blueprint, zeros(Int16, 4), sols; time_limit=32)
    end
    display(n)
end