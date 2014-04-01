class DoubleElimination < Tournament
  before_create :build_loser_and_final_games

  # return a game of the third-place playoff
  def third_place
    Game.find_by(tournament: self, bracket:3, round:1, match:2)
  end

  def build_third_place_game
    self.games.build(bracket:3, round:1, match:2)
  end
end
