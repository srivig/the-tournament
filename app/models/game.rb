#coding: utf-8
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
  # validate  :has_valid_winner, on: :update

  default_scope {order(bracket: :asc, round: :asc, match: :asc)}

  before_update :reset_ancestors, if: :winner_changed?
  before_update :create_or_update_parent_game_record, if: :winner_changed?, unless: lambda{ self.final? }
  # before_update :set_loser_game, if: lambda{ self.tournament.de? && self.bracket==1 }  # only when de and in winner bracket

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

  def loser_game
    round_num = [(self.round-1)*2, 1].max # 1,2,4,6,8,...
    match_num = ((self.match)%2 == 0) ? (self.match)/2 : (self.match+1)/2
    Game.find_by(tournament: self.tournament, bracket:2, round:round, match:match)
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

  # game初保存時or updateでのwinner変更時に、親gameのrecordをセットする
  def create_or_update_parent_game_record
    parent_record_num = ((self.match)%2 == 0) ? 2 : 1
    parent_game_record = GameRecord.find_or_initialize_by(game:self.parent, record_num: parent_record_num)
    parent_game_record.player = self.winner
    parent_game_record.save!

    # semi-finalのときは3rd placeのも作成
    if self.semi_final?
      third_place_record_num = ((self.match)%2 == 0) ? 2 : 1
      third_place_record = GameRecord.find_or_initialize_by(game:self.tournament.third_place, record_num: third_place_record_num)
      third_place_record.player = self.loser
      third_place_record.save!
    end
  end

  def set_loser_game
    #loser bracketの対象game取得
    loser_game = self.loser_game

    #1st roundはrecord_numは1,2ともあり。2nd以降はrecord_num=2にセット
    if self.round == 1 && (self.match)%2 != 0
      record_num = 1
    else
      record_num = 2
    end

    #game_recordにloserをセット(なければ新規作成)
    loser_game_record = GameRecord.find_or_initialize_by(game:loser_game, record_num: record_num)
    loser_game_record.player = self.loser
    loser_game_record.save!
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

  def semi_final?
    self.round == self.tournament.round_num - 1
  end

  def final?
    self.round == self.tournament.round_num
  end

  def match_name
    if self.round == self.tournament.round_num
      if self.match == 1
        '決勝戦'
      else
        '3位決定戦'
      end
    else
      "第#{self.match}試合"
    end
  end
end
