class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def about
    render layout: 'about'

    @tournament = Tournament.find(1)

    teams = Array.new
    @tournament.games.where(bracket:1, round:1).each do |game|
      teams << game.players.map{|m| m.name}.to_a
    end

    results = Array.new
    for i in 1..@tournament.round_num
      round_res = Array.new  # create result array for each round
      results << round_res
      @tournament.games.where(bracket: 1, round: i).each do |game|
        if game.winner.present? && (game.game_records.first.score == game.game_records.last.score)
          win_record = game.game_records.find_by(winner: true)
          tmp = Array[win_record.score, win_record.score + 0.1]
          tmp.reverse if win_record.record_num == 1
          round_res << tmp
        else
          round_res << game.game_records.map{|m| m.score}.to_a
        end
      end
    end

    # pass the tournament data to javascript
    gon.tournament_data = {
      'teams' => teams,
      'results' => results
    }
  end

  def top
    @tournaments = Tournament.limit(5)
  end
end
