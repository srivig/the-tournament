class Tournament < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :games, dependent: :destroy
  has_many :players, dependent: :destroy

  accepts_nested_attributes_for :players
  accepts_nested_attributes_for :games

  validates_associated :games, on: :create
  validates_associated :players
  validates :user_id, presence: true
  validates :size, presence: true, inclusion: {in: [4,8,16]}
  validates :type, numericality: {only_integer: true}, allow_nil: true
  validates :title, presence: true, length: {maximum: 100}
  validates :place, length: {maximum: 100}, allow_nil: true
  validates :detail, length: {maximum: 500}, allow_nil: true
  validates :url, format: URI::regexp(%w(http https)), allow_blank: true

  default_scope {order(created_at: :desc)}

  before_create :create_players, :create_games
  after_create :set_first_rounds

  def create_players
    for i in 1..self.size do
      self.players.build(name: "Player#{i}", seed: i)
    end
  end

  def create_games
    # winner bracket
    for i in 1..self.round_num do
      match_num = self.size / (2**i)
      match_num.times do |k|
        self.games.build(bracket:1, round:i, match:k+1)
      end
    end
    # 3rd place consolidation
    self.games.build(bracket:1, round: self.round_num, match:2)
  end

  def set_first_rounds
    self.games.where(bracket: 1, round: 1).each do |game|
      game_players = [
        self.players.find_by(seed: 2*(game.match)-1),
        self.players.find_by(seed: 2*(game.match))
      ]
      for i in 1..2
        game.game_records.create(player: game_players[i-1], record_num: i)
      end
    end
  end

  def round_num
    Math.log2(self.size).to_i  #=> return 3 rounds for 8 players (2**3=8)
  end

  # return a game of the third-place playoff
  def third_place
    Game.find_by(tournament: self, bracket:1, round:self.round_num, match:2)
  end

  def category
    self.tag_list.each do |tag|
      category = Category.find_by(tag_name: tag)
      return category if category.present?
    end
    return nil
  end
end
