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

  after_update :reset_ancestor_records, :set_parent_game_record, :set_loser_game_record, if: :winner_changed?

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

  def reset_ancestor_records
    self.ancestor_records.map{|record| record.delete}
  end

  def winner_changed?
    changed = false
    self.game_records.each do |r|
      changed = true if r.previous_changes[:winner].present?
    end
    changed
  end

  def parent
    if self.final?
      nil
    elsif self.semi_final?
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

    if tournament.third_place.present? && self.loser_game != tournament.third_place
      ancestors << tournament.third_place
    end
    ancestors
  end

  def ancestor_records
    ancestor_records = Array.new
    game = self.parent
    while game.try(:parent).present?
      ancestor_records << game.parent_game_record
      game = game.parent
    end
    ancestor_records
  end

  def parent_game_record
    GameRecord.find_or_initialize_by(game: self.parent, record_num: self.parent_record_num) if self.parent.present?
  end

  def loser_game_record
    GameRecord.find_or_initialize_by(game: self.loser_game, record_num: self.loser_record_num) if self.loser_game.present?
  end

  def set_parent_game_record
    if self.parent.present?
      target_record = self.parent_game_record
      target_record.player = self.winner
      target_record.save!

      self.parent.game_records.map{|r| r.reset_result}
    end
  end

  def set_loser_game_record
    if self.loser_game.present?
      target_record = self.loser_game_record
      target_record.player = self.loser
      target_record.save!

      self.loser_game.game_records.map{|r| r.reset_result}
    end
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
      if self.bracket == 3 && self.round == 2
        '再決勝'
      else
        '決勝戦'
      end
    elsif self.third_place?
      '3位決定戦'
    else
      "第#{self.match}試合"
    end
  end
end
