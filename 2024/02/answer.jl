const total_cubes = Dict("red" => 12, "green" => 13, "blue" => 14)

function is_safe(report)
    decreasing = report[1] < report[2]
    for i in 1:(length(report)-1)
        a = report[i]
        b = report[i+1]
        if !(1 <= abs(a - b) <=3) || (a < b) != decreasing
            return false
        end
    end
    return true
end

# Part 1

let safes = 0
    for line in eachline("input")
        v = parse.(Int, split(line))
        safes += is_safe(v)
    end
    display(safes)
end

# Part 2

let safes = 0
    for line in eachline("input")
        v_ = parse.(Int, split(line))
        for j = 1:length(v_)
            v = cat(v_[1:j-1], v_[j+1:end]; dims=1)
            safe = true
            decreasing = v[1] < v[2]
            for i in 1:(length(v)-1)
                a = v[i]
                b = v[i+1]
                if !(1 <= abs(a - b) <=3) || (a < b) != decreasing
                    safe = false
                    break
                end
            end
            if safe
                safes +=1
                break
            end
        end
    end
    display(safes)
end