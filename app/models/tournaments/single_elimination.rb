class SingleElimination < Tournament
  def third_place
    Game.find_by(tournament: self, bracket:1, round:self.round_num, match:2) if self.consolation_round
  end

  def final
    Game.find_by(tournament: self, bracket:1, round:self.round_num, match:1)
  end

  def build_third_place_game
    self.games.build(bracket:1, round: self.round_num, match:2)
  end

  def round_name(args)
    bracket = args[:bracket] || 1
    round = args[:round]

    if round == self.round_num
      '決勝ラウンド'
    elsif round == self.round_num - 1
      '準決勝'
    else
      "#{round}回戦"
    end
  end
end
