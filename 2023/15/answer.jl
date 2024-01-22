using DataStructures

function HASH(s)
    return reduce((current, a) -> ((current + Int(a)) * 17) % 256, s; init = 0)
end

# Part 1

let lines = readlines("input")
    results_sum = 0
    for s in eachsplit(lines[1], ',')
        current = 0
        for c in s
            current += Int(c)
            current *= 17
            current = current % 256
        end
        results_sum += current
    end
    display(results_sum)
end

# Part 2

function findfirst(key, list::MutableLinkedList)
    ind = 0
    for (i, v) in enumerate(list)
        if v[1] == key
            ind = i
            break
        end
    end
    return ind    
end

function delete_key!(hashmap, key)
    box = hashmap[HASH(key) + 1]
    ind = findfirst(key, box)
    if !iszero(ind)
        delete!(box, ind)
    end
end

function map_key_to_val!(hashmap, key, val)
    box = hashmap[HASH(key) + 1]
    ind = findfirst(key, box)
    if iszero(ind)
        push!(box, (key, val))
    else
        box[ind] = (key, val)
    end
end

let lines = readlines("input")
    hashmap = [MutableLinkedList{Tuple{SubString{String}, UInt8}}() for _ = 1:256]
    for s in eachsplit(lines[1], ',')
        if last(s) == '-'
            delete_key!(hashmap, s[1:end-1])
        else
            map_key_to_val!(hashmap, s[1:end-2], UInt8(s[end]-'0'))
        end
    end
    
    display(sum(enumerate(hashmap)) do (i, box)
        return sum(enumerate(box); init=0) do (k, a)
            i * k * a[2]
        end
    end)
end