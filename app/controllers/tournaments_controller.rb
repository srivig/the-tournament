class TournamentsController < ApplicationController
  def index
    @tournaments = Tournament.all
  end

  def show
    @tournament = Tournament.find(params[:id])

    teams = Array.new
    @tournament.games.where(bracket:1, round:1).each do |game|
      teams << game.players.order(seed: :asc).map{|m| m.name}.to_a
    end

    results = Array.new
    for i in 1..@tournament.round_num
      round_res = Array.new  # create result array for each round
      results << round_res
      @tournament.games.where(bracket: 1, round: i).each do |game|
        #FIXME: add 0.1 to score when the game is draw
        if game.winner.present? && (game.game_records.first.score == game.game_records.last.score)
          win_record = game.game_records.find_by(winner: true)
          tmp = Array[win_record.score, win_record.score + 0.1]
          tmp.reverse if win_record.record_num == 1
          round_res << tmp
        else
          round_res << game.game_records.sort_by{|r| r.record_num}.map{|m| m.score}.to_a
        end
      end
    end

    # pass the tournament data to javascript
    gon.tournament_data = {
      'teams' => teams,
      'results' => results
    }
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)

    # add tmp players
    for i in 1..@tournament.size do
      @tournament.players.build(name: "Player#{i}", seed: i)
    end

    # construct games
      # winner bracket
      for i in 1..@tournament.round_num do
        match_num = @tournament.size / (2**i)
        match_num.times do |k|
          @tournament.games.build(bracket:1, round:i, match:k+1)
        end
      end
      # 3rd place consolidation
      @tournament.games.build(bracket:1, round: @tournament.round_num, match:2)

    respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tournament }
      else
        flash.now[:alert] = "Failed on saving the tournament."
        format.html { render action: 'new' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to @tournament, notice: 'Tournament was successfully updated.' }
        format.json { head :no_content }
      else
        flash.now[:alert] = "Failed on saving the tournament."
        format.html { render action: 'edit' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def tournament_params
      params.require(:tournament).permit(:id, :title, :user_id, :desc, :place, :size, players_attributes: [:id, :name, :group])
    end
end
