class PlayersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_player, only: [:show, :edit, :update, :destroy]
  before_action :set_tournament, only: [:index, :edit_all]
  load_and_authorize_resource

  def index
  end

  def edit
  end

  def edit_all
  end

  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to tournament_players_path(@player.tournament), notice: I18n.t('flash.player.update.success')}
        format.json { head :no_content }
      else
        flash.now[:alert] = I18n.t('flash.player.update.failure')
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

    def set_tournament
      @tournament = Tournament.find(params[:tournament_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:id, :tournament_id, :seed, :name, :group, :country)
    end
end
