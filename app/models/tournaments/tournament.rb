class Tournament < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :games, -> { order(bracket: :asc, round: :asc, match: :asc) }, dependent: :destroy
  has_many :players, -> { order(seed: :asc) }, dependent: :destroy

  accepts_nested_attributes_for :players
  accepts_nested_attributes_for :games

  validates_associated :games, on: :create
  validates_associated :players
  validates :user_id, presence: true
  validates :size, presence: true, inclusion: {in: [4,8,16]}
  validates :type, presence: true, inclusion: {in: ['SingleElimination', 'DoubleElimination']}
  validates :title, presence: true, length: {maximum: 100}
  validates :place, length: {maximum: 100}, allow_nil: true
  validates :detail, length: {maximum: 500}, allow_nil: true
  validates :url, format: URI::regexp(%w(http https)), allow_blank: true
  validates :consolation_round, presence: true, inclusion: {in: [true,false]}, allow_blank: true
  validates :secondary_final, presence: true, inclusion: {in: [true,false]}, allow_blank: true

  default_scope {order(created_at: :desc)}

  before_create :build_players, :build_winner_games, :build_third_place_game
  after_create :create_first_round_records

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
        teams << game.game_records.map{|r| (r.player.name.present?) ? r.player.name : '--'}.to_a  if i == 1

        # Set match Info
        res =  game.game_records.map{|r| r.score}.to_a
        # Bye Game
        if game.bye == true
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] = 0.3
          res[win_record.record_num]   = 0.2
        # Same Score Game
        elsif game.finished? && (game.game_records.first.score == game.game_records.last.score)
          win_record = game.game_records.find_by(winner: true)
          res[win_record.record_num-1] += 0.1
        # Unfinished Game
        elsif !game.finished?
          res[0] = res[1] = '--'
        end
        round_res << res
      end
    end
    tournament_data = {teams: teams, results: results}
  end

  def match_data
    match_data = Array.new
    match_data[1] = self.games.map{ |m| "#{self.round_name(bracket: m.bracket, round:m.round)} #{m.match_name}<br>#{m.game_records.map{|r| r.player.name}.join('-')}" }
    match_data
  end

  def build_players
    for i in 1..self.size do
      self.players.build(name: "Player#{i}", seed: i)
    end
  end

  def create_first_round_records
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

  def category
    self.tag_list.each do |tag|
      category = Category.find_by(tag_name: tag)
      return category if category.present?
    end
    return nil
  end

  def build_winner_games
    for i in 1..self.round_num do
      match_num = self.size / (2**i)
      match_num.times do |k|
        self.games.build(bracket:1, round:i, match:k+1)
      end
    end
  end

  def de?
    self.type == 'DoubleElimination'
  end
end
