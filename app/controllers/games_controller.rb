class GamesController < ApplicationController
before_filter :authenticate_user!, except: [:show, :index]
before_action :set_game, only: [:show, :join, :put_card, :end_turn, :edit, :update, :destroy]  
  def index
    @games = Game.all
  end

  def show
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
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Card game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
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
    @mover = Player.find(@game.mover)
    @game.save

    redirect_to game_path
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

  private
    def set_game
      @game = Game.find(params[:id])
      @game.init_state
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
