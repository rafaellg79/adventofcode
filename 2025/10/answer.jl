# Part 1

let lines = readlines("input")
    n = 0
    for line in lines
        s = split(line, ' ')
        indicator_light = s[1][2:end-1]
        wiring_schematics = s[2:end-1]
        
        sol = Dict(collect("."^length(indicator_light)) => 0)
        wiring_schematics = [parse.(Int, split(schematic[2:end-1], ',')) .+ 1 for schematic in wiring_schematics]
        next = [collect("."^length(indicator_light))]
        while !haskey(sol, collect(indicator_light))
            light = popfirst!(next)
            for schematic in wiring_schematics
                copy_light = copy(light)
                for m in schematic
                    copy_light[m] = (copy_light[m] == '.') ? '#' : '.'
                end
                if !haskey(sol, copy_light)
                    sol[copy_light] = sol[light] + 1
                    push!(next, copy_light)
                end
            end
        end
        n += sol[collect(indicator_light)]
    end
    display(n)
end

# Part 2

using JuMP, HiGHS

let lines = readlines("input")
    n = 0
    for line in lines
        s = split(line, ' ')
        wiring_schematics = s[2:end-1]
        joltage = s[end]
        
        wiring_schematics = [parse.(Int, split(schematic[2:end-1], ',')) .+ 1 for schematic in wiring_schematics]
        joltage = parse.(Int, split(joltage[2:end-1], ','))
        
        A = zeros(Int, length(joltage), length(wiring_schematics))
        for i in 1:length(wiring_schematics)
            for m in wiring_schematics[i]
                A[m, i] = 1
            end
        end
        
        # I feel using JuMP is overkill, but I didn't manage to implement a LP solution...
        
        model = Model(HiGHS.Optimizer)
        set_silent(model)
        
        @variable(model, x[1:length(wiring_schematics)], Int, lower_bound=0)
        @objective(model, Min, sum(x));
        @constraint(model, c, A*x .== joltage)
        optimize!(model)
        assert_is_solved_and_feasible(model)
        n += sum(value.(x))
    end
    display(n)
end