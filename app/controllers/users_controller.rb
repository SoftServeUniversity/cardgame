class UsersController < ApplicationController
  def show
  end

  def edit
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(username: params[:username], view_theme: params[:view_theme])
    render action: :edit
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end