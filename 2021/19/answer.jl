using DelimitedFiles

text = reduce((a, b) -> a*'\n'*b, readlines("input"))

scanners = first.(readdlm.(IOBuffer.(split(text, "\n\n")), ',', Int; header=true))
scanners = map(scanners) do scanner
            [scanner[i, :] for i = 1:size(scanner, 1)]
           end

orientation_matrices = [[1 0 0;0 1 0;0 0 1], [1 0 0;0 0 1;0 1 0],
                        [0 1 0;1 0 0;0 0 1], [0 1 0;0 0 1;1 0 0],
                        [0 0 1;0 1 0;1 0 0], [0 0 1;1 0 0;0 1 0]]

reflex_matrices = [[i 0 0; 0 j 0; 0 0 k] for i in [-1, 1], j in [-1, 1], k in [-1, 1]]
transforms = vec([ref*ori for ori in orientation_matrices, ref in reflex_matrices])

next_scanners = [1]
visited_scanners = Set{Int}()

scanners_position = Vector{Vector{Int}}(undef, length(scanners))
scanners_transform = Vector{Matrix}(undef, length(scanners))

scanners_transform[1] = [1 0 0; 0 1 0; 0 0 1]
scanners_position[1] = [0, 0, 0]

while !isempty(next_scanners)
    n = pop!(next_scanners)
    push!(visited_scanners, n)
    scanner1 = scanners[n]
    for (m, scanner2) in enumerate(scanners)
        if m in visited_scanners || isdefined(scanners_transform, m)
            continue
        end
        for beacon1 in scanner1, beacon2 in scanner2, T in transforms
            are_neighbors = true
            common_beacons = 0
            translation = beacon1 .- T * beacon2
            for beacon3 in scanner2
                relative_pos_n = T * beacon3 .+ translation
                if maximum(abs, relative_pos_n) <= 1000
                    if (relative_pos_n in scanner1)
                        common_beacons += 1
                    else
                        are_neighbors = false
                        break
                    end
                end
            end
            if are_neighbors && common_beacons >= 12
                push!(next_scanners, m)
                Tn = scanners_transform[n]
                scanners_transform[m] = Tn * T
                scanners_position[m] = Tn * translation .+ scanners_position[n]
                break
            end
        end
    end
end

beacons = Set{Vector{Int}}()
for (n, scanner) in enumerate(scanners)
    T, translation = scanners_transform[n], scanners_position[n]
    beacons_absolute_position = map(x->T*x.+translation, scanner)
    push!.(Ref(beacons), beacons_absolute_position)
end

manhattans_distance = (a, b) -> sum(abs, a.-b)

display(length(beacons))
display(maximum([manhattans_distance(a, b) for a in scanners_position, b in scanners_position]))