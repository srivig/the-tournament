class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show]

  def show
  end

  private
    def set_user
      @user = User.find(params[:id])
      @tournaments = @user.tournaments.all
    end
end
