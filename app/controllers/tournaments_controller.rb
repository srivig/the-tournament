class TournamentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_tournament, only: [:show, :edit, :update, :destroy]

  def index
    tournaments = Tournament.search_tournaments(params)
    @tournaments = tournaments.page(params[:page]).per(15)
  end

  def show
    gon.push({
      tournament_data: @tournament.tournament_data,
      skip_consolation_round: !@tournament.consolation_round,
      countries: @tournament.players.map{|p| p.country.try(:downcase)},
      match_data: @tournament.match_data
    })
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    @tournament.user = current_user

    respond_to do |format|
      if @tournament.save
        @tournament = @tournament
        format.html { redirect_to @tournament, notice: 'Tournament was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tournament }
      else
        @tournament = @tournament
        flash.now[:alert] = "Failed on saving the tournament."
        format.html { render action: 'new' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @tournament.update(tournament_params)
        format.html { redirect_to edit_tournament_path(@tournament), notice: 'Tournament was successfully updated.' }
        format.json { head :no_content }
      else
        flash.now[:alert] = "Failed on saving the tournament."
        format.html { render action: 'edit' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_path }
      format.json { head :no_content }
    end
  end

  private
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    def tournament_params
      params.require(:tournament).permit(:id, :title, :user_id, :detail, :type, :place, :url, :size, :consolation_round, :tag_list, :double_elimination, players_attributes: [:id, :name, :group, :country])
    end
end
