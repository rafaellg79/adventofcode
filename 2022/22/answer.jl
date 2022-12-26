let input = readlines("input")
    board = fill(-1, (202, 202))
    
    tiles = Dict(' ' => -1, '.' => 0, '#' => 1)
    
    (board_input, instructions_input) = split(join(input, "\n"), "\n\n")
    board_input = split(board_input, "\n")
    
    for (i, line) in enumerate(board_input)
        board[i+1, 2:(length(line)+1)] .= get.(Ref(tiles), collect(line), -1)
    end
    
    instructions = first.(findall(r"L|R", instructions_input))
    instructions = broadcast((a, b) -> tuple(parse(Int, instructions_input[(a+1):b-1]), instructions_input[b]), [0; instructions[1:end-1]...], instructions)
    push!(instructions, (39, ' '))
    
    start = findfirst(==(0), board[1:2,:])
    right = CartesianIndex(0, 1)
    down = CartesianIndex(1, 0)
    left = CartesianIndex(0, -1)
    up = CartesianIndex(-1, 0)
    facing_array = [right, down, left, up]
    
    # Part 1
    
    function move(board, pos, facing, steps)
        final_pos = pos
        for i = 1:steps
            if board[final_pos + facing] > 0
                return final_pos
            elseif board[final_pos + facing] < 0
                mirror_pos = final_pos
                while board[mirror_pos] >= 0
                    mirror_pos -= facing
                end
                mirror_pos += facing
                if board[mirror_pos] == 1
                    return final_pos
                else
                    final_pos = mirror_pos
                end
            else
                final_pos += facing
            end
        end
        return final_pos
    end
    
    pos = start
    facing_ind = 1
    facing = facing_array[facing_ind]
    for (steps, rotation) in instructions
        pos = move(board, pos, facing, steps)
        if rotation == ' '
            continue
        end
        facing_ind = mod(facing_ind + ((rotation == 'R') ? 1 : -1), 1:4)
        facing = facing_array[facing_ind]
    end
    display(sum([(pos.I .- 1)...; (facing_ind-1)] .* [1000; 4; 1]))
    
    # Part 2
    board_wrap = Dict()

    l = Int(sqrt(div(count(>=(0), board), 6)))
    faces_vertices = [[ [CartesianIndex(i, j), CartesianIndex(i+l-1, j), CartesianIndex(i, j+l-1), CartesianIndex(i+l-1, j+l-1)] for i in 2:l:size(board, 1), j in 2:l:size(board, 2)]...]
    filter!(vertices -> all(vertice -> board[vertice]>=0, vertices), faces_vertices)
    dist = (a, b) -> sum(abs, (a - b).I)
    
    vertices_groups = [
                       [CartesianIndex(102, 2), CartesianIndex(52, 52), CartesianIndex(51, 52)],
                       [CartesianIndex(151, 2), CartesianIndex(152, 2), CartesianIndex(2, 52)],
                       [CartesianIndex(102, 51), CartesianIndex(101, 52), CartesianIndex(102, 52)],
                       [CartesianIndex(151, 51), CartesianIndex(152, 51), CartesianIndex(151, 52)],
                       [CartesianIndex(2, 102), CartesianIndex(2, 101), CartesianIndex(201, 2)],
                       [CartesianIndex(51, 102), CartesianIndex(51, 101), CartesianIndex(52, 101)],
                       [CartesianIndex(2, 151), CartesianIndex(201, 51), CartesianIndex(151, 101)],
                       [CartesianIndex(51, 151), CartesianIndex(102, 101), CartesianIndex(101, 101)]
                      ]
    
    edges = []
    for vertices in faces_vertices
        for (i, vertice) in enumerate(vertices), neighbor in vertices[i+1:end]
            if dist(vertice, neighbor) == l-1
                normal = CartesianIndex(sign.((vertice-vertices[findfirst(x -> (x != neighbor) && (dist(vertice, x) == l-1), vertices)]).I))
                push!(edges, (vertice, neighbor, normal))
            end
        end
    end
    
    edge_pairs = []
    same_group = (vertice, neighbor, group) -> (vertice in group) && (neighbor in group)
    for (i, edge) in  enumerate(edges), mapped_edge in edges[i+1:end]
        if any(group -> same_group(edge[1], mapped_edge[1], group), vertices_groups) && any(group -> same_group(edge[2], mapped_edge[2], group), vertices_groups)
            push!(edge_pairs, (edge, mapped_edge))
        elseif any(group -> same_group(edge[1], mapped_edge[2], group), vertices_groups) && any(group -> same_group(edge[2], mapped_edge[1], group), vertices_groups)
            push!(edge_pairs, (edge, (mapped_edge[2], mapped_edge[1], mapped_edge[3])))
        end
    end
    
    for (edge, mapped_edge) in edge_pairs
        a, b, normal = edge
        c, d, mapped_normal = mapped_edge
        dir = CartesianIndex(sign.((b-a).I))
        mapped_dir = CartesianIndex(sign.((d-c).I))
        for i = 0:(l-1)
            board_wrap[(a+i*dir, normal)] = (c+i*mapped_dir, -mapped_normal)
            board_wrap[(c+i*mapped_dir, mapped_normal)] = (a+i*dir, -normal)
        end
    end
    
    function move_cube(board, pos, facing, steps, board_wrap)
        final_pos = pos
        for i = 1:steps
            if board[final_pos + facing] > 0
                return (final_pos, facing)
            elseif board[final_pos + facing] < 0
                wrapped_pos, wrapped_facing = board_wrap[(final_pos, facing)]
                if board[wrapped_pos] == 1
                    return (final_pos, facing)
                else
                    final_pos = wrapped_pos
                    facing = wrapped_facing
                end
            else
                final_pos += facing
            end
        end
        return (final_pos, facing)
    end
    
    pos = start
    facing_ind = 1
    facing = facing_array[facing_ind]
    facing_to_ind = Dict(right => 1, down => 2, left => 3, up => 4)
    
    for (steps, rotation) in instructions
        pos, facing = move_cube(board, pos, facing, steps, board_wrap)
        if rotation == ' '
            continue
        end
        facing_ind = facing_to_ind[facing]
        facing_ind = mod(facing_ind + ((rotation == 'R') ? 1 : -1), 1:4)
        facing = facing_array[facing_ind]
    end
    
    display(sum([(pos.I .- 1)...; (facing_ind-1)] .* [1000; 4; 1]))
end