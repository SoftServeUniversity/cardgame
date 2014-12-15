class UsersController < ApplicationController
  def show
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(username: params[:username], view_theme: params[:view_theme])
    redirect_to user_show_path
  end

	def statistic
		@users = User.all.order("win_count DESC")
	end
	private

  def set_user
    @user = User.find(params[:id])
  end
end