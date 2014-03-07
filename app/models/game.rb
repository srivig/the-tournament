# -*- coding: utf-8 -*-
class Game < ActiveRecord::Base
  has_many :game_records, dependent: :destroy
  has_many :players, through: :game_records
  belongs_to :tournament

  accepts_nested_attributes_for :game_records

  validates_associated :game_records
  validates :tournament_id, presence: true, on: :update
  validates :bracket, presence: true, inclusion: {in: [1,2,3]}
  validates :round, presence: true, numericality: {only_integer: true}
  validates :match, presence: true, numericality: {only_integer: true}
  validates :bye, inclusion: {in: [true, false]}, allow_nil: true

  before_update :reset_ancestors, if: :winner_changed?
  after_update :set_parent_game, if: lambda{ self.finished? }, unless: lambda{ self.final? }

  def reset_ancestors
    self.ancestors.map{|game| game.game_records.delete_all }
  end

  def winner_changed?
    self.game_records.first.winner_changed? || self.game_records.second.winner_changed?
  end

  #ペアになるgameを取得(決勝ラウンドではペアがないので除外)
  def pair
    unless self.final?
      pair_match_id = (self.match%2 == 1) ? self.match+1 : self.match-1
      pair = self.tournament.games.find_by(bracket: 1, round: self.round, match: pair_match_id)
    end
  end

  #親gameを取得(決勝ラウンドでは親がないので除外)
  def parent
    unless self.final?
      parent_match_id = (self.match%2 == 1) ? (self.match+1)/2 : (self.match)/2
      parent = self.tournament.games.find_by(bracket: 1, round: self.round+1, match: parent_match_id)
    end
  end

  # 先祖game(直系の親たち)を取得(include third-place playoff)
  def ancestors
    ancestors = Array.new
    game = self
    while game.parent.present?
      ancestors << game.parent
      game = game.parent
    end
    ancestors << self.tournament.third_place unless self.final?
    ancestors
  end

  def set_parent_game
    #相方も処理済みで親gameのgame_recordsがまだなければ作成
    if self.pair.finished? && self.parent.game_records.blank?
      # add game_records!
      players = Array[self.pair.winner]
      (self.match%2 == 1) ? players.unshift(self.winner) : players.push(self.winner)
      for i in 1..2
        self.parent.game_records.create(player: players[i-1], record_num: i)
      end

      # semi-finalのときは3rd placeのも作成
      if self.semi_final?
        players = Array[self.pair.loser]
        (self.match%2 == 1) ? players.unshift(self.loser) : players.push(self.loser)
        for i in 1..2
          self.tournament.third_place.game_records.create(player: players[i-1], record_num: i)
        end
      end
    end
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

  def semi_final?
    self.round == self.tournament.round_num - 1
  end

  def final?
    self.round == self.tournament.round_num
  end
end
