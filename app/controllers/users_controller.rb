class UsersController < ApplicationController
  def show
  end

  def edit
  end
  
  def update
    @user = User.find(params[:id])
    @user.username = params[:username]
    @user.save
    redirect_to action: 'show'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end