class UsersController < ApplicationController
  protect_from_forgery with: :exception

  def show
    render json: respond_to_json
  end

  def edit
  end
  
  def update
    set_user
    @user.update(username: params[:username], view_theme: params[:view_theme])
    render json: respond_to_json
  end
	def statistic
		@users = User.all.order("win_count DESC")
	end
	private

	def set_user
	  @user = User.find(params[:id])
	end

  def respond_to_json
    stat = {
      games_played: self.current_user.games_count,
      games_won: self.current_user.win_count,
      games_lose: self.current_user.lose_count,
      username: self.current_user.username,
      view_theme: self.current_user.view_theme
    }
  end

end