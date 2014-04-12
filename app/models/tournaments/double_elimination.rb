class DoubleElimination < Tournament
  before_create :build_loser_and_final_games

  def third_place
    self.games.find_by(bracket:3, round:1, match:2) if self.consolation_round
  end

  def final
    self.games.find_by(bracket:3, round:1, match:1)
  end

  def build_third_place_game
    self.games.build(bracket:3, round:1, match:2, type: 'Final')
  end

  def build_loser_and_final_games
    loser_round_num = self.loser_round_num
    for i in 1..loser_round_num do
      match_num_base = (loser_round_num+1-i).quo(2).ceil - 1  #2ラウンドごとに試合数が変わる(e.g. 4-4-2-2-1-1)
      (2**match_num_base).times do |k|
        self.games.build(bracket:2, round:i, match:k+1, type: 'Loser')
      end
    end
    2.times do |i|
      self.games.build(bracket:3, round:i+1, match:1, type: 'Final') #決勝戦(secondary finalも作っておく)
    end
  end

  def loser_round_num
    (self.round_num-1)*2
  end

  def round_name(args)
    bracket = args[:bracket] || 1
    round = args[:round]

    if bracket == 3
      '決勝ラウンド'
    elsif (bracket==1 && round==self.round_num) || (bracket==2 && round==loser_round_num)
      '準決勝'
    else
      "#{round}回戦"
    end
  end

  def tournament_data
    teams = Array.new
    results = Array.new

    winner_results = Array.new
    results << winner_results
    for i in 1..self.round_num
      round_res = Array.new  # create result array for each round
      winner_results << round_res
      self.games.where(bracket: 1, round: i).each do |game|
        # Set team info
        teams << game.game_records.map{|r| (r.player.name.present?) ? r.player.name : '--'}.to_a  if i == 1

        # Set match Info
        res =  game.game_records.map{|r| r.score}.to_a
        # Bye Game
        if game.bye == true
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] = 0.3
          res[win_record.record_num]   = 0.2
        # Same Score Game
        elsif game.winner.present? && (game.game_records.first.score == game.game_records.last.score)
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] += 0.1
        end
        round_res << res
      end
    end

    loser_results = Array.new
    results << loser_results
    for i in 1..self.loser_round_num
      round_res = Array.new  # create result array for each round
      loser_results << round_res
      self.games.where(bracket: 2, round: i).each do |game|
        # Set match Info
        res =  game.game_records.map{|r| r.score}.to_a
        # Bye Game
        if game.bye == true
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] = 0.3
          res[win_record.record_num]   = 0.2
        # Same Score Game
        elsif game.winner.present? && (game.game_records.first.score == game.game_records.last.score)
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] += 0.1
        end
        round_res << res
      end
    end

    final_results = Array.new
    results << final_results
    round_res = Array.new  # create result array for each round
    final_results << round_res
    self.games.where(bracket: 3, round: 1).each do |game|
      # Set match Info
      res =  game.game_records.map{|r| r.score}.to_a
      # Bye Game
      if game.bye == true
        win_record = game.game_records.find_by(winner: true)
        res[win_record.record_num-1] = 0.3
        res[win_record.record_num]   = 0.2
      # Same Score Game
      elsif game.winner.present? && (game.game_records.first.score == game.game_records.last.score)
        win_record = game.game_records.find_by(winner: true)
        res[win_record.record_num-1] += 0.1
      end
      round_res << res
    end

    tournament_data = {teams: teams, results: results}
  end
end
