class GameRecord < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  validates :game_id, presence: true
  validates :player_id, presence: true
  validates :record_num, presence: true, inclusion: {in: [1,2]}
  validates :score, presence: true, numericality: {only_integer: true}, on: :update
  validates :winner, presence: true, inclusion: {in: [true, false]}, on: :update, allow_blank: true

  before_validation :set_default_score, on: :update

  def set_default_score
    self.score ||= 0
  end
end
