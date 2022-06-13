using DelimitedFiles

a = readdlm("input", Any)

# horizonyal position, depth, aim, final depth
pos = [0, 0, 0, 0]

for i in 1:size(a, 1)
    if a[i, 1] == "forward"
        pos[1] += a[i, 2]
        pos[4] += pos[3] * a[i, 2]
    elseif a[i, 1] == "up"
        pos[2] -= a[i, 2]
        pos[3] -= a[i, 2]
    else a[i, 1] == "down"
        pos[2] += a[i, 2]
        pos[3] += a[i, 2]
    end
end

display(pos[1] * pos[2])
display(pos[1] * pos[4])