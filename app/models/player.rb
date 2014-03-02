class Player < ActiveRecord::Base
  belongs_to :tournament
  has_many :game_records
  has_many :games, through: :game_records

  validates :tournament_id, presence: true
  validates :seed, presence: true, numericality: {only_integer: true}
  validates :name, presence: true, length: {maximum: 100}
  validates :group, length: {maximum: 100}, allow_nil: true
  validates :desc, length: {maximum: 500}, allow_nil: true
end
