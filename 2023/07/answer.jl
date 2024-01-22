function strength(hand)
    num_cards = ntuple(i -> count(==(hand[i]), hand), Val(5))
    max_cards = maximum(num_cards)
    # Five of a kind
    if max_cards == 5
        return 6
    # Four of a kind
    elseif max_cards == 4
        return 5
    # Full house
    elseif extrema(num_cards) == (2, 3)
        return 4
    # Three of a kind
    elseif max_cards == 3
        return 3
    # Two pair
    elseif count(==(2), num_cards) == 4
        return 2
    # One pair
    elseif count(==(2), num_cards) == 2
        return 1
    else
        return 0
    end
end

# Part 1

let lines = readlines("input")
    cards = Char[('0' .+ (2:9))..., 'T', 'J', 'Q', 'K', 'A']
    dict = Dict{Char, Int}(cards .=> 2:(length(cards)+1))
    
    total_winning = 0
    hands = Array{NTuple{6, Int}}(undef, length(lines))
    bids = zeros(Int, length(lines))
    
    for (i, line) in enumerate(lines)
        bid = @view line[7:end]
        hand = ntuple(c -> dict[line[c]], Val(5))
        hands[i] = (strength(hand), hand...)
        bids[i] = parse(Int, bid)
    end
    
    ranks = sort!(collect(zip(hands, bids)); by=first)
    
    for (i, rank) in enumerate(ranks)
        total_winning += i * rank[2]
    end
    
    display(total_winning)
end

# Part 2

function strength_joker(hand)
    max_str = 0
    for card in hand
        substituted_hand = ntuple(i -> hand[i] == 1 ? card : hand[i], Val(5))
        max_str = max(max_str, strength(substituted_hand))
    end
    return max_str
end

let lines = readlines("input")
    cards = Char['J', ('0' .+ (2:9))..., 'T', 'Q', 'K', 'A']
    dict = Dict{Char, Int}(cards .=> 1:length(cards))
    
    total_winning = 0
    hands = Array{NTuple{6, Int}}(undef, length(lines))
    bids = zeros(Int, length(lines))
    
    for (i, line) in enumerate(lines)
        bid = @view line[7:end]
        hand = ntuple(c -> dict[line[c]], Val(5))
        hands[i] = (strength_joker(hand), hand...)
        bids[i] = parse(Int, bid)
    end
    
    ranks = sort!(collect(zip(hands, bids)); by=first)
    
    for (i, rank) in enumerate(ranks)
        total_winning += i * rank[2]
    end
    
    display(total_winning)
end