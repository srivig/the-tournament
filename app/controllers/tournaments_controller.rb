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
    is_tutorial_needed = flash[:notice].present? && current_user.tournaments.count == 1

    gon.push({
      is_tutorial_needed: is_tutorial_needed,
      tournament_data: @tournament.tournament_data,
      skip_secondary_final: (@tournament.de?) ? !@tournament.secondary_final : false,
      skip_consolation_round: !@tournament.consolation_round,
      countries: @tournament.players.map{|p| p.country.try(:downcase)},
      match_data: @tournament.match_data,
      scoreless: @tournament.scoreless?
    })
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
    if !current_user.creatable?
      link = "(<a href=\"/gift\">無料作成枠を増やす</a>)"
      flash[:alert] = "トーナメント作成数の上限に達しています。#{link}".html_safe
      redirect_to root_path
    end

    @tournament = Tournament.new
  end

  def create
    @tournament = SingleElimination.new(tournament_params)  #TODO: Fix when enabling double elimination
    @tournament.user = current_user

    respond_to do |format|
      if @tournament.save && current_user.creatable?
        # GAにイベントを送信
        flash[:log] = "<script>ga('send', 'event', 'tournament', 'create');</script>".html_safe

        flash[:notice] = I18n.t('flash.tournament.create.success')
        format.html { redirect_to tournament_edit_players_path(@tournament) }
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
      success_url = tournament_edit_games_path(@tournament)
      success_notice = I18n.t('flash.players.update.success')
      failure_url = 'players/edit_all'
      failure_notice = I18n.t('flash.players.update.failure')
    else
      success_url = tournament_edit_players_path(@tournament)
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
      format.html { redirect_to root_path, notice: 'トーナメントを削除しました' }
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
