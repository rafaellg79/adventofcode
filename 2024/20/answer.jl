const dirs = [CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1)]

function compute_distances(M, start)
    indexing_fuction = LinearIndices(M)
    coordinates = CartesianIndices(M)
    next = BitSet()
    push!(next, indexing_fuction[start])
    
    dists = fill(typemax(Int), size(M))
    dists[start] = 0
    
    while !isempty(next)
        n = coordinates[pop!(next)]
        d = dists[n]
        for dir in dirs
            neighbor = n+dir
            if !checkbounds(Bool, M, neighbor)
                continue
            end
            if M[neighbor] != '#' && d+1 < dists[neighbor]
                push!(next, indexing_fuction[neighbor])
                dists[neighbor] = d+1
            end
        end
    end
    return dists
end

function cheat_improvements(dists_from_start, dists_from_end, best_time, cheat_duration, min_save)
    c = 0
    for I in CartesianIndices(dists_from_start)[2:end-1, 2:end-1]
        d = dists_from_start[I]
        w = 0
        for i in -cheat_duration:cheat_duration
            for j in -cheat_duration+abs(i):cheat_duration-abs(i)
                n = I + i*dirs[1] + j*dirs[3]
                if checkbounds(Bool, dists_from_start, n) && dists_from_start[n] != typemax(Int) && dists_from_end[I] != typemax(Int)
                    if best_time - (dists_from_start[n] + (abs(i)+abs(j)) + dists_from_end[I]) >= min_save
                        c += 1
                    end
                end
            end
        end
    end
    return c
end

# Part 1

let lines = readlines("input")
    track = permutedims(hcat(collect.(lines)...))
    
    start_pos = findfirst(==('S'), track)
    end_pos = findfirst(==('E'), track)
    
    dists_from_start = compute_distances(track, start_pos)
    dists_from_end = compute_distances(track, end_pos)
    
    display(cheat_improvements(dists_from_start, dists_from_end, dists_from_start[end_pos], 2, 100))
end

# Part 2

let lines = readlines("input")
    track = permutedims(hcat(collect.(lines)...))
    
    start_pos = findfirst(==('S'), track)
    end_pos = findfirst(==('E'), track)
    
    dists_from_start = compute_distances(track, start_pos)
    dists_from_start = compute_distances(track, start_pos)
    dists_from_end = compute_distances(track, end_pos)
    
    display(cheat_improvements(dists_from_start, dists_from_end, dists_from_start[end_pos], 20, 100))
end