class Tournament < ActiveRecord::Base
  has_many :games
  belongs_to :user
  has_many :players
  accepts_nested_attributes_for :players
  accepts_nested_attributes_for :games

  after_create :set_first_rounds

  def set_first_rounds
    self.games.where(bracket: 1, round: 1).each do |game|
      game_players = [
        self.players.find_by(seed: 2*(game.match)-1),
        self.players.find_by(seed: 2*(game.match))
      ]
      for i in 1..2
        game.game_records.create(player: game_players[i-1], record_num: i)
      end
    end
  end

  def round_num
    Math.log2(self.size).to_i  #=> return 3 rounds for 8 players (2**3=8)
  end
end
