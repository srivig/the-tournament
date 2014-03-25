class Player < ActiveRecord::Base
  belongs_to :tournament
  has_many :game_records
  has_many :games, through: :game_records

  validates :tournament_id, presence: true, on: :update
  validates :seed, presence: true, numericality: {only_integer: true}
  validates :name, presence: true, length: {maximum: 100}
  validates :group, length: {maximum: 100}, allow_nil: true
  validates :desc, length: {maximum: 500}, allow_nil: true

  default_scope {order(seed: :asc)}

  before_validation :set_seed_game, on: :update, if: Proc.new{|player| player.name.blank?}

  def set_seed_game
    match_id = (self.seed/2) + (self.seed%2)
    game = Game.find_by(tournament_id: self.tournament.id, bracket: 1, round: 1, match: match_id)
    unless game.bye == true
      self.name = '--'
      game.bye = true
      game.game_records.each do |r|
        r.score = 0
        r.winner = (r.player == self) ? false : true
      end
      game.save
    end
  end
end
