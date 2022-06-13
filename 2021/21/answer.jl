initial_positions = parse.(Int, [line[29:end] for line in readlines("input")])
score = [0, 0]
rolls = 0

let positions = copy(initial_positions)
    while maximum(score) < 1000
        player = rolls % 2 + 1 # 3 = 1 mod 2
        global rolls+=3
        mean_dice_rolls = rolls-1
        positions[player] = (positions[player] + 3*mean_dice_rolls - 1) % 10 + 1
        score[player] += positions[player]
    end
end

display(rolls * minimum(score))

dice_outcomes = zeros(Int, 9)
for i = 1:3, j = 1:3, k = 1:3
    dice_outcomes[i+j+k]+=1
end

wining_score = 21
possible_configurations = zeros(Int, cld(4wining_score, 3), wining_score, wining_score, 10, 10)
possible_configurations[1, 1, 1, initial_positions[1], initial_positions[2]] = 1
wins = zeros(Int, 2)

for turn = 1:size(possible_configurations, 1)
    player = (turn - 1) % 2 + 1
    player1_turn = (turn ÷ 2) + 1
    player2_turn = (turn - 1) ÷ 2 + 1
    for score1 = player1_turn:size(possible_configurations, 2), score2 = player2_turn:size(possible_configurations, 3), pos1 = 1:10, pos2 = 1:10
        configurations = possible_configurations[turn, score1, score2, pos1, pos2]
        if configurations == 0
            continue
        end
        
        for moves = 3:9
            new_configurations = configurations * dice_outcomes[moves]
            new_positions = [pos1, pos2]
            new_scores = [score1, score2]
            
            new_positions[player] = (new_positions[player] + moves - 1) % 10 + 1
            new_scores[player] += new_positions[player]
            
            if new_scores[player] <= wining_score
                possible_configurations[turn+1, new_scores..., new_positions...] += new_configurations
            else
                wins[player] += new_configurations
            end
        end
    end
end

display(maximum(wins))