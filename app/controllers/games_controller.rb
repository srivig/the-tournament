class GamesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  # GET /games
  # GET /games.json
  def index
    @tournament = Tournament.find(params[:tournament_id])
  end

  # GET /games/1/edit
  def edit
    if @game.players.blank?
      flash[:alert] = "This game is not ready to start!"
      redirect_to tournament_games_path(@game.tournament)
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to tournament_games_path(@game.tournament), notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        flash.now[:alert] = "Failed on saving the game."
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:id, :tournament_id, :bracket, :round, :match, game_records_attributes: [:id, :player_id, :score, :winner])
    end

    def set_winner
      win_record =  game_params[:game_records_attributes].sort_by{|k,v| v["score"]}.reverse.first[0]
      params["game"]["game_records_attributes"][win_record]["winner"] = true
    end
end
