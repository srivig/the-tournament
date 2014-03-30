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

  def self.search_tournaments(params)
    if params[:q]
      tournaments = Tournament.where('title LIKE ? OR detail LIKE ?', "%#{params[:q]}%", "%#{params[:q]}%")
    elsif params[:tag]
      tournaments = Tournament.tagged_with(params[:tag])
    elsif params[:category]
      if params[:category] != 'others'
        tags = Category.where(category_name: params[:category]).map(&:tag_name)
        tournaments = Tournament.tagged_with(tags, any:true)
      else
        tags = Category.all.map(&:tag_name)
        tournaments = Tournament.tagged_with(tags, exclude:true)
      end
    else
      tournaments = Tournament.all
    end
    tournaments
  end

  def tournament_data
    teams = Array.new
    results = Array.new
    for i in 1..self.round_num
      round_res = Array.new  # create result array for each round
      results << round_res
      self.games.where(bracket: 1, round: i).each do |game|
        # Set team info
        teams << game.players.map{|m| (m.name.present?) ? m.name : '--'}.to_a  if i == 1

        # Set match Info
        res =  game.game_records.map{|m| m.score}.to_a
        # Bye Game
        if game.bye == true
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] = 0.3
          res[win_record.record_num]   = 0.2
        # Same Score Game
        elsif game.winner.present? && (game.game_records.first.score == game.game_records.last.score)
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] += 0.1
        end
        round_res << res
      end
    end
    tournament_data = {teams: teams, results: results}
  end

  def match_data
    self.games.map{ |m|
      "#{self.round_name(m.round)} #{m.match_name}<br>#{m.game_records.map{|r| r.player.name}.join('-')}"
    }
  end

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

  def round_name(i)
    if i == self.round_num
      '決勝ラウンド'
    elsif i == self.round_num - 1
      '準決勝'
    else
      "#{i}回戦"
    end
  end
end
