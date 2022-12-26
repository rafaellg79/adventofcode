using Graphs

let input = readlines("input")
    
    mutable struct Folder
        name :: String
        parent :: Int
        size :: Int
    end
    
    G = SimpleDiGraph(1)
    graph_to_folder = Dict{Int, Folder}(1 => Folder("/", 1, 0))
    folder_to_graph = Dict{String, Int}("/" => 1)
    
    current_line = 1
    current_folder = 1
    while current_line <= length(input)
        line = input[current_line]
        words = split(line)
        folder = graph_to_folder[current_folder]
        if words[1] == "\$"
            if words[2] == "cd"
                if words[3] == "/"
                    current_folder = 1
                elseif words[3] == ".."
                    current_folder = folder.parent
                else
                    sub_folder = get(folder_to_graph, folder.name*words[3]*"/", nv(G) + 1)
                    if !has_vertex(G, sub_folder)
                        add_vertex!(G)
                        graph_to_folder[sub_folder] = Folder(folder.name*words[3]*"/", current_folder, 0)
                        folder_to_graph[graph_to_folder[sub_folder].name] = sub_folder
                    end
                    add_edge!(G, current_folder, sub_folder)
                    current_folder = sub_folder
                end
            elseif words[2] == "ls"
                current_line += 1
                folder.size = 0
                
                while current_line <= length(input)
                    line = input[current_line]
                    if line[1] == '\$'
                        current_line -= 1
                        break
                    end
                    words = split(line)
                    file_size = tryparse(Int, words[1])
                    if isnothing(file_size)
                        sub_folder = get(folder_to_graph, folder.name*words[2]*"/", nv(G) + 1)
                        if !has_vertex(G, sub_folder)
                            add_vertex!(G)
                            graph_to_folder[sub_folder] = Folder(folder.name*words[2]*"/", current_folder, 0)
                            folder_to_graph[folder.name*words[2]*"/"] = sub_folder
                        end
                        add_edge!(G, current_folder, sub_folder)
                    else
                        folder.size += file_size
                    end
                    
                    current_line += 1
                end
                graph_to_folder[current_folder] = folder
            end
        end
        current_line+=1
    end
    
    for folder_ind in reverse!(topological_sort_by_dfs(G))
        folder = graph_to_folder[folder_ind]
        for sub_folder in neighbors(G, folder_ind)
            folder.size += graph_to_folder[sub_folder].size
        end
        graph_to_folder[folder_ind] = folder
    end
    
    # Part 1
    display(sum(v -> graph_to_folder[v].size > 100000 ? 0 : graph_to_folder[v].size, 1:nv(G)))
    
    # Part 2
    total_space = 70000000
    free_space = total_space - graph_to_folder[1].size
    required_space = 30000000 - free_space
    display(minimum(map(v -> graph_to_folder[v].size, filter!(v -> graph_to_folder[v].size > required_space, collect(1:nv(G))))))
end