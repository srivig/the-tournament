require 'open-uri'

class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_blog_rss, only: [:top, :about]


  def about
    sample_id = (Rails.env=='production') ? 158 : 1
    @tournament = Tournament.find(sample_id)
    gon.push({
      tournament_data: @tournament.tournament_data,
      skip_secondary_final: (@tournament.de?) ? !@tournament.secondary_final : false,
      skip_consolation_round: !@tournament.consolation_round,
      countries: @tournament.players.map{|p| p.country.try(:downcase)},
      match_data: @tournament.match_data,
      scoreless: @tournament.scoreless?
    })
  end

  def top
    @pickup = Tournament.where(pickup: true).order(created_at: :desc).first
    @tournaments = Tournament.finished.limit(10)
    @unfinished_tnmts = Tournament.where(finished: false).limit(10)
    @user_tnmts = current_user.tournaments.limit(10) if current_user
  end


  private

    def set_blog_rss
      @rss= SimpleRSS.parse open('http://blog.the-tournament.jp/rss')
    end
end
