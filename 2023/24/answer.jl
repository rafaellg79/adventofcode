function det2(a, b, c, d)
    return a * d - b * c
end

function norm(v)
    return sqrt(sum(x -> x^2, v))
end

function cross(v1, v2)
    return [v1[2] * v2[3] - v1[3] * v2[2]; v1[3] * v2[1] - v1[1] * v2[3]; v1[1] * v2[2] - v1[2] * v2[1]]
end

function parse_input(lines)
    positions = zeros(Int, 3, length(lines))
    velocities = zeros(Int, 3, length(lines))
    for (i, line) in enumerate(lines)
        j = 1
        current = positions
        s = 1
        for c in line
            if isdigit(c)
                current[j, i] = current[j, i] * 10 + s * Int(c-'0')
            elseif c == '-'
                s = -1
            elseif c == ','
                j += 1
                s = 1
            elseif c == '@'
                current = velocities
                j = 1
                s = 1
            end
        end
    end
    return positions, velocities
end

# Part 1

let lines = readlines("input")
    score = 0
    positions, velocities = parse_input(lines)

    B = Array{Int}(undef, 2)
    intersection = Array{Float64}(undef, 2)
    
    for i = 1:size(positions, 2)
        p1 = @view positions[1:2, i]
        v1 = @view velocities[1:2, i]
        for j = i+1:size(positions, 2)
            p2 = @view positions[1:2, j]
            v2 = @view velocities[1:2, j]
            
            @. B = p2 - p1
            D = -det2(v1[1], v2[1], v1[2], v2[2])
            if iszero(D)
                continue
            end
            D1 = -det2(B[1], v2[1], B[2], v2[2])
            D2 = det2(v1[1], B[1], v1[2], B[2])
            s = (D1 / D, D2 / D)
            @. intersection = p1 + s[1] * v1
            if all(x -> 200000000000000 <= x <= 400000000000000, intersection) && all(>=(0), s)
                score+=1
            end
        end
    end
    
    display(score)
end

# Part 2

let lines = readlines("input")
    score = 0
    positions, velocities = parse_input(@view lines[1:3])
    
    # the line equation describing hailstone 1 is
    # L1(t) = P1 + V1 * t
    # for each coordinate we have
    # x + vx * t1 = px1 + vx1 * t1
    # isolate t to get
    # t1 = (x-px1) / (vx1-vx)
    # we can then pair x and y coordinates to obtain
    # (x-px1) / (vx1-vx) = (y-py1) / (vy1-vy)
    # rearranging the terms
    # (x-px1) * (vy1-vy) = (y-py1) * (vx1-vx)
    # expanding the equations
    # x*vy1 - x*vy - px1*vy1 + px1*vy = y*vx1-y*vx-py1*vx1+py1*vx
    # repeating the process for hailstone 2 we get
    # x*vy2 - x*vy - px2*vy2 + px2*vy = y*vx2-y*vx-py2*vx2+py2*vx
    # subtracting the equations we can eliminate the non-linear terms to get
    # (vy1-vy2)*x-px1*vy1+px2*vy2+(px1-px2)*vy = (vx1-vx2)*y-py1*vx1+py2*vx2+(py1-py2)*vx
    # finally rearrange the equation to have the unknowns on lhs
    # (vy1-vy2)*x+(-vx1+vx2)*y+(-py1+py2)*vx+(px1-px2)*vy = -py1*vx1+py2*vx2+px1*vy1-px2*vy2
    # to build the linear system just pair each axis and repeat the process on another hailstone
    #(vy1-vy2)*x-(vx1-vx2)*y-(py1-py2)*vx+(px1-px2)*vy = -py1*vx1+py2*vx2+px1*vy1-px2*vy2
    #(vz1-vz2)*x-(vx1-vx2)*z-(pz1-pz2)*vx+(px1-px2)*vz = -pz1*vx1+pz2*vx2+px1*vz1-px2*vz2
    #(vz1-vz2)*y-(vy1-vy2)*z-(pz1-pz2)*vy+(py1-py2)*vz = -pz1*vy1+pz2*vy2+py1*vz1-py2*vz2
    #(vy1-vy3)*x-(vx1-vx3)*y-(py1-py3)*vx+(px1-px3)*vy = -py1*vx1+py3*vx3+px1*vy1-px3*vy3
    #(vz1-vz3)*x-(vx1-vx3)*z-(pz1-pz3)*vx+(px1-px3)*vz = -pz1*vx1+pz3*vx3+px1*vz1-px3*vz3
    #(vz1-vz3)*y-(vy1-vy3)*z-(pz1-pz3)*vy+(py1-py3)*vz = -pz1*vy1+pz3*vy3+py1*vz1-py3*vz3
    
    A = [(velocities[2, 1]-velocities[2, 2]) (-velocities[1, 1]+velocities[1, 2]) 0 (-positions[2, 1]+positions[2, 2]) (positions[1, 1]-positions[1, 2]) 0;
         (velocities[3, 1]-velocities[3, 2]) 0 (-velocities[1, 1]+velocities[1, 2]) (-positions[3, 1]+positions[3, 2]) 0 (positions[1, 1]-positions[1, 2]);
         0 (velocities[3, 1]-velocities[3, 2]) (-velocities[2, 1]+velocities[2, 2]) 0 (-positions[3, 1]+positions[3, 2]) (positions[2, 1]-positions[2, 2]);
         (velocities[2, 1]-velocities[2, 3]) (-velocities[1, 1]+velocities[1, 3]) 0 (-positions[2, 1]+positions[2, 3]) (positions[1, 1]-positions[1, 3]) 0;
         (velocities[3, 1]-velocities[3, 3]) 0 (-velocities[1, 1]+velocities[1, 3]) (-positions[3, 1]+positions[3, 3]) 0 (positions[1, 1]-positions[1, 3]);
         0 (velocities[3, 1]-velocities[3, 3]) (-velocities[2, 1]+velocities[2, 3]) 0 (-positions[3, 1]+positions[3, 3]) (positions[2, 1]-positions[2, 3])]
    
    b = [-positions[x2, l1]*velocities[x1, l1]+positions[x2, l2]*velocities[x1, l2]+positions[x1, l1]*velocities[x2, l1]-positions[x1, l2]*velocities[x2, l2] for (l1, l2, x1, x2) in [(1, 2, 1, 2), (1, 2, 1, 3), (1, 2, 2, 3), (1, 3, 1, 2), (1, 3, 1, 3), (1, 3, 2, 3)]]
    
    x, y, z, vx, vy, vz = A \ b
    display(round(Int64, x+y+z))
end