class UsersController < ApplicationController
  def show
  end

  def edit
  end
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    render action: :show
  end
	def statistic
		@users = User.all.order("win_count DESC")
	end
	private

	def set_user
	  @user = User.find(params[:id])
	end

  def user_params
    params.require(:user).permit(:username, :view_theme)
  end
end