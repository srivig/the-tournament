#coding: utf-8
class Game < ActiveRecord::Base
  has_many :game_records, -> { order(record_num: :asc) }, dependent: :destroy
  has_many :players, through: :game_records
  belongs_to :tournament

  accepts_nested_attributes_for :game_records

  validates_associated :game_records
  validates :tournament_id, presence: true, on: :update
  validates :bracket, presence: true, inclusion: {in: [1,2,3]}
  validates :round, presence: true, numericality: {only_integer: true}
  validates :match, presence: true, numericality: {only_integer: true}
  validates :bye, inclusion: {in: [true, false]}, allow_nil: true
  validate  :has_valid_winner, on: :update

  after_update :reset_ancestors, :set_parent_game_record, :set_loser_game_record, if: :winner_changed?

  def has_valid_winner
    winners = Array.new
    game_records.each do |r|
      winners << r  if r.winner == true
    end

    if winners.size == 1
      loser = (game_records - winners).first
      winner = winners.first
      errors.add(:game_records, "score is invalid") unless winner.score >= loser.score
    else
      errors.add(:game_records, "winner is not valid")
    end
  end

  def reset_ancestors
    self.ancestors.map{|game| game.game_records.delete_all }
  end

  def winner_changed?
    changed = false
    self.game_records.each do |r|
      changed = true if r.previous_changes[:winner].present?
    end
    changed
  end

  def parent
    if self.semi_final?
      self.tournament.final
    else
      self.tournament.games.find_by(bracket: self.bracket, round: self.round+1, match: self.parent_match_id)
    end
  end

  # 先祖game(直系の親たち)を取得(except for direct parent)
  def ancestors
    ancestors = Array.new
    game = self.parent
    while game.try(:parent).present?
      ancestors << game.parent
      game = game.parent
    end
    tournament = self.becomes(Game).tournament
    ancestors << tournament.third_place unless self.loser_game == tournament.third_place
    ancestors
  end

  def set_target_game_record(game, record_num, player)
    if game.present?
      target_game_record = GameRecord.find_or_initialize_by(game: game, record_num: record_num)
      target_game_record.player = player
      target_game_record.save!

      game.game_records.map{|r| r.reset_result}
    end
  end

  def set_parent_game_record
    set_target_game_record(self.parent, self.parent_record_num, self.winner)
  end

  def set_third_place_record
    set_target_game_record(self.tournament.third_place, self.third_place_record_num, self.loser)
  end

  def set_loser_game_record
    set_target_game_record(self.loser_game, self.loser_record_num, self.loser)
  end

  def ready?
    self.game_records.count == 2
  end

  def finished?
    self.winner.present?
  end

  def winner
    self.game_records.find_by(winner: true).try(:player)
  end

  def loser
    self.game_records.find_by(winner: false).try(:player) if self.winner.present?
  end

  def match_name
    if self.final?
      '決勝戦'
    elsif self.third_place?
      '3位決定戦'
    else
      "第#{self.match}試合"
    end
  end
end
