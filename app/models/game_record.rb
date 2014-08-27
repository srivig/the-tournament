# == Schema Information
#
# Table name: game_records
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  player_id  :integer
#  record_num :integer
#  score      :integer
#  winner     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class GameRecord < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  validates :game_id, presence: true, uniqueness: {scope: :record_num}
  validates :player_id, presence: true
  validates :record_num, presence: true, inclusion: {in: [1,2]}
  validates :score, presence: true, numericality: {only_integer: true}, on: :update, allow_blank: true
  validates :winner, presence: true, inclusion: {in: [true, false]}, on: :update, allow_blank: true

  before_validation :set_default_score, on: :update

  def set_default_score
    self.score ||= 0
  end

  def pair_record
    pair_record_num = 3 - self.record_num # return 1 for 2, 2 for 1
    GameRecord.find_by(game:self.game, record_num:pair_record_num)
  end

  def reset_result
    self.score = nil
    self.winner = nil
    self.save!
  end
end
