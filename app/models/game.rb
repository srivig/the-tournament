# -*- coding: utf-8 -*-
class Game < ActiveRecord::Base
  has_many :game_records
  has_many :players, through: :game_records
  belongs_to :tournament
  accepts_nested_attributes_for :game_records

  # before_update :clear_parent_games, if: :winner_changed?
  after_update :set_parent_game, if: lambda{ self.finished? }, unless: lambda{ self.final? }

  def clear_parent_games
  end

  def winner_changed?
    # self.game_records.find_by(winner: true).try(:player) == self.winner
  end

  def set_parent_game
    #相方のgameを取得
    pair_match_id = (self.match%2 == 1) ? self.match+1 : self.match-1
    pair = self.tournament.games.find_by(bracket: 1, round: self.round, match: pair_match_id)

    #親gameを取得
    parent_match_id = (self.match%2 == 1) ? (self.match+1)/2 : (self.match)/2
    parent = self.tournament.games.find_by(bracket: 1, round: self.round+1, match: parent_match_id)

    #相方も処理済みで親gameのgame_recordsがまだなければ作成
    if pair.finished? && parent.game_records.blank?
      # add game_records!
      players = Array[pair.winner]
      (self.match%2 == 1) ? players.unshift(self.winner) : players.push(self.winner)
      for i in 1..2
        parent.game_records.create(player: players[i-1], record_num: i)
      end

      # semi-finalのときは3rd placeのも作成
      if self.semi_final?
        third_place = self.tournament.games.find_by(bracket:1, round:self.round+1, match:2)
        players = Array[pair.loser]
        (self.match%2 == 1) ? players.unshift(self.loser) : players.push(self.loser)
        for i in 1..2
          third_place.game_records.create(player: players[i-1], record_num: i)
        end
      end
    end
  end

  def finished?
    self.winner.present?
  end

  def joined_by?(player)
    self.users.include?(player)
  end

  def winner
    self.game_records.find_by(winner: true).try(:player)
  end

  def loser
    self.game_records.find_by(winner: nil).player if self.winner.present?
  end

  def semi_final?
    self.round == self.tournament.round_num - 1
  end

  def final?
    self.round == self.tournament.round_num
  end

  def opponent(player)
    if self.joined_by?(player)
      self.game_records.where.not(user_id: current_user.id).first.try(:player)
    end
  end
end
