# Part 1

let lines = readlines("input")
    number = lines[1]
    disk_space = sum(digit->parse(Int, digit), number)
    disk = zeros(Int, disk_space)
    
    iter = 1
    for i in 1:2:length(number)-1
        n = parse(Int, number[i])
        disk[iter:iter+n-1] .= cld(i, 2)
        iter += n + parse(Int, number[i+1])
    end
    disk[iter:end] .= cld(length(number), 2)
    
    first_zero = 1
    
    for i = length(disk):-1:1
        if disk[i] == 0
            continue
        end
        for j = first_zero:i
            if disk[j] == 0
                disk[j] = disk[i]
                disk[i] = 0
                first_zero = j
                break
            end
        end
    end
    
    checksum = 0
    for i = 1:length(disk)
        if disk[i] > 0
            checksum += (disk[i]-1) * (i-1)
        end
    end
    
    display(checksum)
end

# Part 2

let lines = readlines("input")
    number = lines[1]
    disk_space = sum(digit->parse(Int, digit), number)
    disk = zeros(Int, disk_space)
    
    iter = 1
    for i in 1:2:length(number)-1
        n = parse(Int, number[i])
        disk[iter:iter+n-1] .= cld(i, 2)
        iter += n + parse(Int, number[i+1])
    end
    disk[iter:end] .= cld(length(number), 2)
    
    first_zero = findfirst(iszero, disk)
    
    i = length(disk)
    while i > first_zero
        j = findprev(!=(disk[i]), disk, i) + 1
        file_size = i-j+1
        k = first_zero
        while k <= j-file_size
            if all(iszero, disk[k:k+file_size-1])
                disk[k:k+file_size-1] .= disk[j]
                disk[j:i] .= 0
                if k == first_zero
                    first_zero = findnext(iszero, disk, first_zero+file_size)
                end
                break
            end
            k = findnext(iszero, disk, findnext(!=(0), disk, k))
        end
        i = findprev(x -> x!=(disk[i]) && x != 0, disk, i)
    end
    
    checksum = 0
    for i = 1:length(disk)
        if disk[i] > 0
            checksum += (disk[i]-1) * (i-1)
        end
    end
    
    display(checksum)
end