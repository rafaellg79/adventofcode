# Part 1

let lines = readlines("input")
    s = map(x -> parse.(Int, x), split.(lines, ','))
    area = 0
    for i in 1:length(s)
        for j in i+1:length(s)
            area = max(area, (abs(s[i][1] - s[j][1])+1) * (abs(s[i][2] - s[j][2])+1))
        end
    end
    display(area)
end

# Part 2

# Test for horizontal and vertical lines only
function line_intersect(v11, v12, v21, v22)
    if min(v11[1], v12[1]) < max(v21[1], v22[1]) && min(v21[1], v22[1]) < max(v11[1], v12[1]) &&
       min(v11[2], v12[2]) < max(v21[2], v22[2]) && min(v21[2], v22[2]) < max(v11[2], v12[2])
        return true
    else
        return false
    end
end

let lines = readlines("input")
    s = map(x -> CartesianIndex(parse.(Int, x)...), split.(lines, ','))
    area = 0
    for i in 1:length(s)
        for j in i+1:length(s)
            rect_area = (abs(s[i][1] - s[j][1])+1) * (abs(s[i][2] - s[j][2])+1)
            if rect_area < area
                continue
            end
            v1 = s[i]
            v2 = s[j]
            inside = true
            for i in 1:length(s)
                if line_intersect(v1, v2, s[i], s[mod(i+1, 1:length(s))])
                    inside = false
                    break
                end
            end
            if inside
                area = rect_area
            end
        end
    end
    
    display(area)
end