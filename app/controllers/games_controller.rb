class GamesController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_game, only: [:show, :join, :put_card, :reload, :end_turn, :end_game, :edit, :update, :destroy]  

  def index
    @games = Game.all
    render json: @games
  end

  def show
    if @game
      render json: resp_to_json 
    else
      render json: { status: "ended"}
    end

  end

  def my_game
    redirect_to games_path
  end

  def reload
  end

  def new
    @game = Game.new
    render json: @game
  end

  def create
    @game = Game.new game_params
    @game.do_init_first_player self.current_user
    @game.players[0].save
    @game.save
      if @game.save
        render json: @game
      else
        render json: @game.errors
      end
  end

  def update
    @game.do_init_second_player self.current_user
    @game.players[1].save
    @game.do_preparation_for_game
    save_game @game
    render json: @game
  end

  def put_card
    card = self.current_user.player.put_card(params[:rang], params[:suite])
    puts "____________________________--"
    puts card.rang
    puts card.suite
    @game.get_card_from_player card, self.current_user.player, @game.attacker
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
      render json: @game
    end
  end

  def end_turn
    puts "Controller End Turn"
    @game.end_turn self.current_user.player
    save_game @game
    render json: @game
  end

  def destroy
    @game.destroy

    render json: @game
  end

  def end_game 
    if !@game
        render json: @game
    end
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

    render json: {status: "ended"}
  end

  private
  def set_game
    @game = Game.find(params[:id])
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

  def resp_to_json
    # Potentially shipabble product increment
    resp = {
      game_name: @game.name,
      game_description: @game.description,
      game_state: @game.state,
      current_user: self.current_user.id
    }

    if @game.mover
      start_game_params = { game_mover: @game.mover.user.id,
      game_attacker: @game.attacker.user.id,
      game_defender: @game.attacker.user.id,
      table_cards: @game.table.table_cards,
      player_cards: self.current_user.player.player_cards,
      trump: @game.deck.trump,
      deck_cards_count: @game.deck.cursor }
      resp.merge! (start_game_params)
    end

    resp
  end
end