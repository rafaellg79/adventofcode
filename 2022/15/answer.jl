using Scanf

let input = readlines("input")
    sensors = []
    beacons = []
    for i = 1:length(input)
        _, sx, sy, bx, by = @scanf input[i] "Sensor at x=%i, y=%i: closest beacon is at x=%i, y=%i" Int Int Int Int
        push!(sensors, (sx, sy))
        push!(beacons, (bx, by))
    end
    sensors = hcat(sensors...)
    beacons = hcat(beacons...)
    
    dist = (s, b) -> sum(abs, s .- b)
    
    # Part 1
    y = 2000000
    beacons_at_y = Set(filter(beacon -> beacon[2] == y, beacons))
    empty_pos = Set()
    for (sensor, beacon) in zip(sensors, beacons)
        d = dist(sensor, beacon)
        s = (sensor[1], y)
        delta = (0, 0)
        while dist(s .+ delta, sensor) <= d
            if !(s.+delta in beacons_at_y)
                push!(empty_pos, s.+delta)
            end
            if !(s.-delta in beacons_at_y)
                push!(empty_pos, s.-delta)
            end
            delta = (delta[1]+1, 0)
        end
    end
    
    display(length(empty_pos))
    
    # Part 2
    max_dist = 4000000
    distress_beacon = (-1, -1)
    
    for i = 0:max_dist
        ranges = Tuple{Int, Int}[]
        for (sensor, beacon) in zip(sensors, beacons)
            d = dist(sensor, beacon)
            dist_to_i = dist(sensor, (i, sensor[2]))
            if dist_to_i <= d
                delta = d - dist_to_i
                if sensor[1] <= max_dist && sensor[2] >= 0
                    push!(ranges, (max(0, sensor[2] - delta), min(max_dist, sensor[2] + delta)))
                end
            end
        end
        sort!(ranges)
        
        ranges_union = foldl(ranges; init = Tuple{Int, Int}[]) do r0, r1
            if isempty(r0)
                return push!(r0, r1)
            end
            r0_end = r0[end]
            if r0_end[2] >= r1[1]
                r0[end] = (r0_end[1], max(r0_end[2], r1[2]))
            else
                push!(r0, r1)
            end
            return r0
        end
        
        if length(ranges_union) > 1
            distress_beacon = (i, ranges_union[1][2]+1)
        end
        
        if distress_beacon != (-1, -1)
            break
        end
    end
    display(distress_beacon)
    
    tuning_frequency = (x, y) -> x * 4000000 + y
    display(tuning_frequency(distress_beacon...))
end