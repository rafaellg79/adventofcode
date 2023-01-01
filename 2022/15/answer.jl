using Scanf

let input = readlines("input")
    sensors = Tuple{Int, Int}[]
    beacons = Tuple{Int, Int}[]
    for i = 1:length(input)
        _, sx, sy, bx, by = @scanf input[i] "Sensor at x=%i, y=%i: closest beacon is at x=%i, y=%i" Int Int Int Int
        push!(sensors, (sx, sy))
        push!(beacons, (bx, by))
    end
    sensors = vcat(sensors)
    beacons = vcat(beacons)
    
    dist = (s, b) -> sum(abs, s .- b)
    dists = [dist(sensor, beacon) for (sensor, beacon) in zip(sensors, beacons)]
    
    # Part 1
    y = 2000000
    beacons_at_y = count(beacon -> beacon[2] == y, unique(beacons))
    empty_pos = Set()
    
    function flatten(ranges)
        R = sort(ranges)
        flattened_ranges = [R[1]]
        for range in R
            if last(flattened_ranges[end]) >= first(range)
                flattened_ranges[end] = first(flattened_ranges[end]) : max(last(flattened_ranges[end]), last(range))
            else
                push!(flattened_ranges, range)
            end
        end
        return flattened_ranges
    end
    
    ranges_in_y = map(sensors, dists) do sensor, d
        dist = (s, b) -> sum(abs, s .- b)
        center = (sensor[1], y)
        dist_to_center = dist(center, sensor)
        dist_from_center = d - dist_to_center
        if dist_from_center >= 0
            return (center[1]-dist_from_center) : (center[1]+dist_from_center)
        end
        return 1:0
    end
    filter!(!isempty, ranges_in_y)
    
    display(sum(length, flatten(ranges_in_y)) - beacons_at_y)
    
    # Part 2
    function check_adjacents(sensor, d, sensors, dists, max_dist)
        for n in 0:d
            adjacent_pos = (sensor[1] + (d + 1) - n, sensor[2] + n)
            if adjacent_pos[1] < 0 || adjacent_pos[1] > max_dist ||
               adjacent_pos[2] < 0 || adjacent_pos[2] > max_dist
                continue
            end
            
            if all(dist(adjacent_pos, s) > radius for (s, radius) in zip(sensors, dists))
                return adjacent_pos
                break
            end
        end
    end
    
    function find_beacon(sensors, beacons, max_dist)
        dist = (s, b) -> sum(abs, s .- b)
        dists = [dist(sensor, beacon) for (sensor, beacon) in zip(sensors, beacons)]
        for (sensor, d) in zip(sensors, dists)
            if sensor[1] + d + 1 < 0 || sensor[1]+1 > max_dist ||
               sensor[2] + d < 0 || sensor[2] > max_dist
                continue
            end
            distress_beacon = check_adjacents(sensor, d, sensors, dists, max_dist)
            if !isnothing(distress_beacon)
                return distress_beacon
            end
        end
    end
    
    distress_beacon = find_beacon(sensors, beacons, 4000000)
    
    tuning_frequency = (x, y) -> x * 4000000 + y
    display(tuning_frequency(distress_beacon...))
end