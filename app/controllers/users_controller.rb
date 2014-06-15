class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: 'Success on updating user info.' }
        format.json { head :no_content }
      else
        flash.now[:alert] = 'Failed on updating user info.'
        format.html { render edit_user_path(@user) }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
      @tournaments = @user.tournaments.all
    end

    def user_params
      params.require(:user).permit(:email, :email_subscription)
    end
end
