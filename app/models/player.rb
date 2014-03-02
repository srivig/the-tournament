class Player < ActiveRecord::Base
  has_many :game_records
  has_many :games, through: :game_records
  belongs_to :tournament
end
