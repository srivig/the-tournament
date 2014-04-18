class PlayersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  def index
    @tournament = Tournament.find(params[:tournament_id]).becomes(Tournament)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to tournament_players_path(@player.tournament), notice: 'Player was successfully updated.' }
        format.json { head :no_content }
      else
        flash.now[:alert] = "Failed on saving the player."
        format.html { render action: 'edit' }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:id, :tournament_id, :seed, :name, :group, :country)
    end
end
