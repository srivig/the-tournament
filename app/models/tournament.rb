class Tournament < ActiveRecord::Base
  belongs_to :user
  has_many :games, dependent: :destroy
  has_many :players, dependent: :destroy

  accepts_nested_attributes_for :players
  accepts_nested_attributes_for :games

  validates_associated :games
  validates_associated :players
  validates :user_id, presence: true
  validates :size, presence: true, inclusion: {in: [4,8,16]}
  validates :type, numericality: {only_integer: true}, allow_nil: true
  validates :title, presence: true, length: {maximum: 100}
  validates :place, length: {maximum: 100}, allow_nil: true
  validates :desc, length: {maximum: 500}, allow_nil: true

  default_scope {order(created_at: :desc)}

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

  # return a game of the third-place playoff
  def third_place
    Game.find_by(tournament: self, bracket:1, round:self.round_num, match:2)
  end
end
