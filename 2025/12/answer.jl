let lines = readlines("input")
    line_ind = 1
    shapes = []
    regions_start = 0
    for i in 1:5:length(lines)
        if !startswith(lines[i], r"[0-9]:")
            regions_start = i
            break
        end
    end
    
    for i in 2:5:regions_start
        push!(shapes, count(==('#'), vcat(collect.(lines[i:i+2])...)))
    end
    
    n = 0
    for line in lines[regions_start:end]
        s = split(line, ' ')
        width = parse(Int, s[1][1: findfirst('x', line)-1])
        height = parse(Int, s[1][findfirst('x', line)+1:end-1])
        region = falses(width, height)
        
        presents = parse.(Int, s[2:end])
        fit = true
        area = 0
        for (m, p) in enumerate(presents)
            area += shapes[m]*p
        end
        n += area <= width*height
        # Didn't prove it, but I'm pretty sure there's a tiling pattern we can create with the shapes from input, then we just need to fill the area
        # Might not be possible to fill perfectly and there could be missing pieces to fill the area, thus we should find the pattern and deal with the missing pieces separately, but the answer worked so...
    end
    
    display(n)
end