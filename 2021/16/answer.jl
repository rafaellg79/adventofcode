packet = readline("input")

struct Packet
    version::Int8
    type::Int8
    value::Int64
    sub_packets::Array{Packet}
end

bits = join(string.(parse.(Int, collect(packet); base=16); base=2, pad=4))

function decode_packet(packet)
    version = parse(Int, packet[1:3]; base=2)
    type = parse(Int, packet[4:6]; base=2)
    value = -1
    sub_packets = Packet[]
    tail = []
    if type == 4
        offset = 0
        number = BitArray(undef, 0)
        while packet[7+offset] == '1'
            append!(number, parse.(Bool, collect(packet[8+offset:11+offset])))
            offset+=5
        end
        append!(number, parse.(Bool, collect(packet[8+offset:11+offset])))
        reverse!(number)
        @assert length(number.chunks) > 1 "literal requires more than 64 bits to be representable"
        value = reinterpret(Int64, number.chunks[1]) # may consider negative numbers
        tail = @view packet[12+offset:end]
    elseif packet[7] == '0'
        packet_length = parse(Int, packet[8:22]; base=2)
        sub_packet_tail = @view packet[23:22+packet_length]
        while !isempty(sub_packet_tail)
            sub_packet, sub_packet_tail = decode_packet(sub_packet_tail)
            push!(sub_packets, sub_packet)
        end
        tail = @view packet[23+packet_length:end]
    else
        num_sub_packets = parse(Int, packet[8:18]; base=2)
        tail = @view packet[19:end]
        for i = 1:num_sub_packets
            sub_packet, tail = decode_packet(tail)
            push!(sub_packets, sub_packet)
        end
    end
    
    operators = Dict{Int, Function}(0 => sum, 1 => prod, 2 => minimum, 3 => maximum, 4 => (x...)->value, 5 => >, 6 => <, 7 => ==)
    if type < 5
        value = operators[type](p->p.value, sub_packets)
    else
        value = operators[type](sub_packets[1].value, sub_packets[2].value)
    end
    return Packet(version, type, value, sub_packets), tail
end

function sum_versions(packet::Packet)
    if isempty(packet.sub_packets)
        return packet.version
    else
        return packet.version + sum(sum_versions, packet.sub_packets)
    end
end

packet = first(decode_packet(bits))
display(sum_versions(packet))
display(packet.value)