class TournamentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :embed]
  before_action :set_tournament, only: [:show, :edit, :update, :destroy, :embed]
  load_and_authorize_resource

  def index
    tournaments = Tournament.search_tournaments(params)
    @tournaments = tournaments.page(params[:page]).per(15)
  end

  def show
    redirect_to pretty_tournament_path(@tournament, @tournament.encoded_title), status: 301 if params[:title] != @tournament.encoded_title

    gon.push({
      tournament_data: @tournament.tournament_data,
      skip_secondary_final: (@tournament.de?) ? !@tournament.secondary_final : false,
      skip_consolation_round: !@tournament.consolation_round,
      countries: @tournament.players.map{|p| p.country.try(:downcase)},
      match_data: @tournament.match_data,
      scoreless: @tournament.scoreless?
    })

    if @tournament.user == current_user
      if !@tournament.member_registered?
        flash.now[:warning] = view_context.fa_icon("exclamation-circle") + I18n.t('flash.guides.players_reg')
      elsif !@tournament.result_registered?
        flash.now[:warning] = view_context.fa_icon("exclamation-circle") + I18n.t('flash.guides.games_reg')
      end
    end
  end

  def embed
    gon.push({
      tournament_data: @tournament.tournament_data,
      skip_secondary_final: (@tournament.de?) ? !@tournament.secondary_final : false,
      skip_consolation_round: !@tournament.consolation_round,
      countries: @tournament.players.map{|p| p.country.try(:downcase)},
      match_data: @tournament.match_data,
      scoreless: @tournament.scoreless?
    })
    render layout: false
  end

  def new
    @tournament = Tournament.new
  end

  def create
    # @tournament = Tournament.new(tournament_params)
    @tournament = SingleElimination.new(tournament_params)  #TODO: Fix when enabling double elimination
    @tournament.user = current_user
        flash[:notice] = "hogehoge"

    respond_to do |format|
      if @tournament.save
        # GAにイベントを送信
        #flash[:log] = "<script>ga('send', 'event', 'tournament', 'create');</script>".html_safe

        format.html { redirect_to tournament_path(@tournament), notice: I18n.t('flash.tournament.create.success')}
        format.json { render action: 'show', status: :created, location: @tournament }
      else
        flash.now[:alert] = I18n.t('flash.tournament.create.failure')
        format.html { render action: 'new' }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    # Players一覧更新時
    if params[:tournament][:players_attributes].present?
      success_url = tournament_players_path(@tournament)
      success_notice = I18n.t('flash.players.update.success')
      failure_url = 'players/index'
      failure_notice = I18n.t('flash.players.update.failure')
    else
      success_url = edit_tournament_path(@tournament)
      success_notice = I18n.t('flash.tournament.update.success')
      failure_url = {action: 'edit'}
      failure_notice = I18n.t('flash.tournament.update.failure')
    end

    respond_to do |format|
      if @tournament.update(tournament_params)
        # format.html { redirect_to edit_tournament_path(@tournament), notice: 'Tournament was successfully updated.' }
        format.html { redirect_to success_url, notice: success_notice}
        format.json { head :no_content }
      else
        flash.now[:alert] = failure_notice
        format.html { render failure_url }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tournament.destroy
    respond_to do |format|
      format.html { redirect_to tournaments_path, notice: 'トーナメントを削除しました' }
      format.json { head :no_content }
    end
  end

  private
    def set_tournament
      @tournament = Tournament.find(params[:id])
    end

    def tournament_params
      params.require(:tournament).permit(:id, :title, :user_id, :detail, :type, :place, :url, :size, :consolation_round, :tag_list, :double_elimination, :scoreless, players_attributes: [:id, :name, :group, :country])
    end
end
