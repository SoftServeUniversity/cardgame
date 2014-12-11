class UsersController < ApplicationController
	def show
	end

	def statistic
		@users = User.all.order("win_count DESC")
	end
	private

	def set_user
	  @user = User.find(params[:id])
	end
end