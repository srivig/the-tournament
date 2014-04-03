class SingleElimination < Tournament
  # return a game of the third-place playoff
  def third_place
    Game.find_by(tournament: self, bracket:1, round:self.round_num, match:2)
  end

  def final
    Game.find_by(tournament: self, bracket:1, round:self.round_num, match:1)
  end

  def build_third_place_game
    self.games.build(bracket:1, round: self.round_num, match:2)
  end
end
