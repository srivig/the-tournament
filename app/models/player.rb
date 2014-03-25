class Player < ActiveRecord::Base
  belongs_to :tournament
  has_many :game_records
  has_many :games, through: :game_records

  validates :tournament_id, presence: true, on: :update
  validates :seed, presence: true, numericality: {only_integer: true}
  validates :name, length: {maximum: 100}, allow_nil: true
  validates :group, length: {maximum: 100}, allow_nil: true
  validates :desc, length: {maximum: 500}, allow_nil: true

  default_scope {order(seed: :asc)}

  before_update :reset_seed_game, if: :seed_canceled?
  before_update :set_seed_game, on: :update, if: :seed_registered?

  def set_seed_game
    game = self.first_round_game
    if game.bye == true
      self.name = self.name_was
    else
      game.bye = true
      game.game_records.each do |r|
        r.score = 0
        r.winner = (r.player == self) ? false : true
      end
      game.save
    end
  end

  def seed_registered?
    self.name_changed? && self.name.blank?
  end

  def seed_canceled?
    self.name_changed? && self.name_was.blank?
  end

  def reset_seed_game
    game = self.first_round_game
    game.bye = false
    game.save
  end

  def first_round_game
    match_id = (self.seed/2) + (self.seed%2)
    Game.find_by(tournament_id: self.tournament.id, bracket: 1, round: 1, match: match_id)
  end
end
