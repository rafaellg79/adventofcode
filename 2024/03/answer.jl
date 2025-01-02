function parse_mul(line, start)
    valid = true
    n = 0
    i += 3
    while valid && i < length(line)
        i+=1
        k = line[i]
        if isdigit(k)
            n = 10*n + Int(k-'0')
        elseif k == ','
            break
        else
            valid = false
        end
    end
    m = 0
    while valid && i < length(line)
        i += 1
        k = line[i]
        if isdigit(k)
            m = 10*m + Int(k-'0')
        elseif k == ')'
            break
        else
            valid = false
        end
    end
    [range(;start=number.offset, length=length(number.match)) for number in eachmatch(r"[0-9]+", line)]
end

# Part 1

let lines = readlines("input")
    S = 0
    for line in lines
        i = 0
        while i < length(line)-6
            i += 1
            if cmp(line[i:i+3], "mul(") == 0
                valid = true
                n = 0
                i += 3
                while valid && i < length(line)
                    i+=1
                    k = line[i]
                    if isdigit(k)
                        n = 10*n + Int(k-'0')
                    elseif k == ','
                        break
                    else
                        valid = false
                    end
                end
                m = 0
                while valid && i < length(line)
                    i += 1
                    k = line[i]
                    if isdigit(k)
                        m = 10*m + Int(k-'0')
                    elseif k == ')'
                        break
                    else
                        valid = false
                    end
                end
                if valid
                    S += n*m
                end
            end
        end
    end
    display(S)
end

# Part 2

let lines = readlines("input")
    S = 0
    DO = true
    for line in lines
        for i in 1:(length(line)-6)
            if (cmp(line[i:i+3], "mul(") == 0) && DO
                valid = true
                n = 0
                j = i+3
                while j < length(line)
                    j+=1
                    if isdigit(line[j])
                        n = 10*n + Int(line[j]-'0')
                    elseif line[j] == ','
                        break
                    else
                        valid = false
                    end
                end
                m = 0
                while j < length(line)
                    j+=1
                    if isdigit(line[j])
                        m = 10*m + Int(line[j]-'0')
                    elseif line[j] == ')'
                        break
                    else
                        valid = false
                    end
                end
                if valid
                    S += n*m
                end
            elseif cmp(line[i:i+6], "don't()") == 0
                DO = false
            elseif cmp(line[i:i+3], "do()") == 0
                DO = true
            end
        end
    end
    display(S)
end