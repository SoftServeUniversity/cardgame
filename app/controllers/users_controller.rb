class UsersController < ApplicationController
	def show
	end

	private

	def set_user
	  @user = User.find(params[:id])
	end
end