class GamesController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_game, only: [:show, :join, :put_card, :reload, :end_turn, :end_game, :edit, :update, :destroy]  

  def index
    @games = Game.all
    respond_to do |format|
      format.html { render action: 'index' }
      format.js {render :action=>"index.js.erb"}
    end
  end

  def show
    if !@game
      redirect_to games_path
    end
    respond_to do |format|
      format.html { render action: 'show' }
      format.js {render :action=>"show.js.erb"}
    end
  end

  def reload
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new game_params
    @game.init
    @game.init_state
    @game.init_player self.current_user
    @game.players[0].save
    @game.save
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Card game was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @game.init_player self.current_user
    @game.players[1].save
    @game.prepare_game_to_start
    save_game @game
    respond_to do |format|
        format.html { redirect_to @game }
        format.json { head :no_content }
    end
  end

  def put_card
    card = self.current_user.player.put_card(params[:rang], params[:suite])
    puts "____________________________--"
    puts card.rang
    puts card.suite
    @game.get_card_from_player card, self.current_user.player.id
    @game.players[0].save
    @game.players[1].save
    @game.table.save
    @game.save
    if @game.game_ended?
      puts "_______________________________________Game Ended"
      if @game.players[0].cards_count == 0
        puts "_______________________________________Winner player 0"
        @game.winner = @game.players[0]
        @game.loser = @game.players[1]
      else
        puts "_______________________________________Winner player 1"
        @game.winner = @game.players[1]
        @game.loser = @game.players[0]
      end
      @game.save
      puts "_______________________________________Game saved"
      end_game
    else
      redirect_to game_path
    end
  end

  def end_turn
    puts "Controller End Turn"
    @game.end_turn self.current_user.player.id
    save_game @game
    redirect_to game_path
  end

  def destroy
    @game.destroy

    redirect_to games_path
  end

  def end_game
    puts"_______________________________________Controller Action End Game"
    puts"_______________________________________outside"
    if @game.players[1]
      puts"_______________________________________intside player exist"
      @user1 = User.find @game.players[0].user_id
      @user2 = User.find @game.players[1].user_id

      @user1.games_count += 1
      @user2.games_count += 1

      if @game.winner
        puts"_______________________________________inside is winner"
        if @user1 == @game.winner
          @user1.win_count += 1
          @user2.lose_count += 1
        else
          @user2.win_count += 1
          @user1.lose_count += 1
        end
      else
        puts"_______________________________________intside button pressed"
        if current_user == @user1
          @user2.win_count += 1
          @user1.lose_count += 1
        else
          @user1.win_count += 1
          @user2.lose_count += 1
        end
      end
      @user1.save
      @user2.save
    end

    @game.destroy

    redirect_to games_path
  end

  private
  def set_game
    @game = Game.find(params[:id])
    @game.init_state
  rescue
    @game = nil
  end

  def game_params
    params.require(:game).permit(:name, :description)
  end
  def save_game game
    game.players[0].save
    game.players[1].save
    game.table.save
    game.deck.save
    game.save
  end
end
