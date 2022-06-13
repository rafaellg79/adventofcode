target = readline("input")
pos = strip.(split(target[14:end], ','))

x = split(pos[1][3:end], '.')[[1, 3]]
y = split(pos[2][3:end], '.')[[1, 3]]

x = parse.(Int, x)
y = parse.(Int, y)

if x[1] > x[2]
    x .= x[[2, 1]]
end

if y[1] > y[2]
    y .= y[[2, 1]]
end

@assert y[2] - y[1] > 0 "if y=0 is contained in target region any y is a solution if x = sum(1:n) for some n"

if y[1] < 0 
    display((y[1]+1)*y[1]÷2)
else
    display((y[2]+1)*y[2]÷2)
end

N = max(x..., abs.(y)...)
# A[s, v] gives the position at step s given initial velocity v-1
A = zeros(Int, 2N+1, N+1)

for vel = 0:N
    A[1, vel+1] = vel
    if vel < N-1
        A[vel+2, vel+1] = -(vel+1)
    end
    for step = 2:(vel+1)
        A[step, vel+1] = A[step-1, vel+1] + vel-step+1
    end
    for step = (vel+2):size(A, 1)
        A[step, vel+1] = A[step-1, vel+1] + vel-step+1
    end
end

hits = 0
for vel_x = 0:N, vel_y = 0:N
    for step = 1:size(A, 1)
        step_x = A[min(vel_x+1, step), vel_x+1]
        step_y = A[step, vel_y+1]
        if (x[1] <= step_x <= x[2]) && (y[1] <= step_y <= y[2])
            global hits+=1
            break
        end
        if step_x > x[2] || (step_y < y[1] && step >= vel_y)
            break
        end
    end
    if y[1] < 0 && vel_y>0
        for step = 1:size(A, 1)
            step_negative_x = A[step, vel_x+1]
            step_negative_y = A[min(size(A, 1), 2(vel_y-1) + step+1), vel_y]
            if (x[1] <= step_negative_x <= x[2]) && (y[1] <= step_negative_y <= y[2])
                global hits+=1
                break
            end
            if step_negative_x > x[2] || (step_negative_y < y[1] && step >= vel_y)
                break
            end
        end
    end
end

display(hits)