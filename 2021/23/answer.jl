using DataStructures

lines = collect.(readlines("input"))
diagram = fill(' ', length(lines), maximum(length, lines))
for i = 1:length(lines), j = 1:length(lines[i])
    diagram[i, j] = lines[i][j]
end

get_column = (room_type) -> 2*(room_type-'A')+4
get_energy_move_cost = (amphipod) -> 10^(amphipod-'A')

solutions = Dict{String, Int}()

function get_key(hallway, rooms)
    diagram_key = String(hallway)
    for room in values(rooms)
        room_key = ""
        for amphipod in room
            room_key *= amphipod
        end
        diagram_key *= lpad(room_key, 4, '.')
    end
    return diagram_key
end

function get_rooms(diagram)
    rooms = Dict{Char, Stack{Char}}()
    for room_type = 'A':'D'
        room = Stack{Char}()
        for amphipod in diagram[end-1:-1:3, get_column(room_type)]
            if amphipod in 'A':'D'
                push!(room, amphipod)
            end
        end
        rooms[room_type] = room
    end
    return rooms
end

function sort_rooms!(hallway::Vector{Char}, rooms::Dict, capacity::Int)
    key = get_key(hallway, rooms)
    if haskey(solutions, key)
        return solutions[key] 
    end
    
    sorted_rooms = [all(==(room_type), room) for (room_type, room) in rooms]
    full_rooms = length.(values(rooms)).==capacity
    if all(full_rooms) && all(sorted_rooms)
        return 0
    end
    
    min_energy = 10^9
    for (i, (room_type, room)) in enumerate(rooms)
        room_column = get_column(room_type)
        distance_to_hallway = capacity-length(room)
        
        l = '#'=>1
        r = '#'=>length(hallway)
        for (column, amphipod) in enumerate(hallway)
            if amphipod in 'A':'D'
                if l.second < column < room_column
                    l = amphipod=>column
                elseif room_column < column < r.second
                    r = amphipod=>column
                end
            end
        end
        
        if sorted_rooms[i]
            if full_rooms[i]
                continue
            elseif l.first == room_type || r.first == room_type
                move_cost = get_energy_move_cost(room_type)
                total_move_energy = 0
                if l.first == room_type
                    push!(room, l.first)
                    total_move_energy += move_cost * ((room_column-l.second) + distance_to_hallway)
                    hallway[l.second] = '.'
                end
                if r.first == room_type
                    push!(room, r.first)
                    total_move_energy += move_cost * ((r.second-room_column) + distance_to_hallway)
                    hallway[r.second] = '.'
                end
                
                min_energy = min(min_energy, total_move_energy+sort_rooms!(hallway, rooms, capacity))
                
                if r.first == room_type
                    pop!(room)
                    hallway[r.second] = r.first
                end
                if l.first == room_type
                    pop!(room)
                    hallway[l.second] = l.first
                end
            end
        elseif !isempty(room)
            amphipod = pop!(room)
            move_cost = get_energy_move_cost(amphipod)
            vertical_move_energy = (distance_to_hallway+1)*move_cost
            for n = (l.second+1):(r.second-1)
                if hallway[n] == '.'
                    total_move_energy = vertical_move_energy + abs(room_column - n) * move_cost
                    
                    hallway[n] = amphipod
                    min_energy = min(min_energy, total_move_energy+sort_rooms!(hallway, rooms, capacity))
                    hallway[n] = '.'
                end
            end
            push!(room, amphipod)
        end
    end
    solutions[key] = min_energy
    return min_energy
end

function sort_rooms(diagram::Matrix{Char})
    hallway = diagram[2, :]
    hallway[get_column.(collect('A':'D'))] .= '*'
    #doors = filter(I->diagram[I] == '.' && diagram[I+CartesianIndex(1, 0)] != '#' , CartesianIndices(diagram)[2, :])
    rooms = get_rooms(diagram)
    
    return sort_rooms!(hallway, rooms, size(diagram, 1)-3)
end

folded_lines = split("  #D#C#B#A#\n  #D#B#A#C#", '\n')
folded_diagram = fill(' ', length(folded_lines), maximum(length, lines))
for i = 1:length(folded_lines), j = 1:length(folded_lines[i])
    folded_diagram[i, j] = folded_lines[i][j]
end
unfolded_diagram = [diagram[1:3, :]; folded_diagram; diagram[4:end, :]]

display(sort_rooms(diagram))
display(sort_rooms(unfolded_diagram))