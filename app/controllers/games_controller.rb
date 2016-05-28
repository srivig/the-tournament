class GamesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_action :set_tournament, only: [:index, :edit_all]
  load_and_authorize_resource

  def index
  end

  def edit_all
  end

  def edit
    unless @game.ready?
      flash[:alert] = "This game is not ready to start!"
      redirect_to tournament_games_path(@game.tournament)
    end
  end

  def update
    respond_to do |format|
      tnmt_finished = @game.tournament.finished?
      if @game.update(game_params)
        # GAにイベントを送信(トーナメント完了時のみ)
        tnmt_finished_now = @game.tournament.finished? && !tnmt_finished #親tournamentがはじめてfinishedになったことを検知
        flash[:log] = "<script>ga('send', 'event', 'tournament', 'finished');</script>".html_safe if tnmt_finished_now

        format.html { redirect_to tournament_edit_games_path(@game.tournament), notice: I18n.t('flash.game.update.success')}
        format.json { head :no_content }
      else
        flash.now[:alert] = I18n.t('flash.game.update.failure')
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end


  private
    def set_game
      @game = Game.find(params[:id])
    end

    def set_tournament
      @tournament = Tournament.find(params[:tournament_id])
    end

    def game_params
      params.require(:game).permit(:id, :tournament_id, :bracket, :round, :match, :comment, game_records_attributes: [:id, :player_id, :score, :winner, :comment])
    end
end
