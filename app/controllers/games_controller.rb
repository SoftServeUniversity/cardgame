class GamesController < ApplicationController
  include GamesHelper

  before_filter :authenticate_user!, except: [:show, :index]
  before_action :set_game, only: [:show, :join, :put_card, :reload, :end_turn, :end_game, :edit, :update, :destroy]  
  before_action :set_user, only: [:end_game]
  def index
    @games = Game.all
    response = []
    @games.each do |game|
      res = {
        id: game.id,
        description: game.description,
        name: game.name,
        state: game.state,
        owner: game.players[0].user,
        player2: game.players[1]
      };
      response << res
    end
    render json: response
  end

  def show
    if @game
      render json: resp_to_json 
    else
      render json: { status: "ended"}
    end
  end

  def new
    @game = Game.new
    render json: @game
  end

  def create
    @game = Game.new game_params
    @game.do_init_first_player current_user
    @game.players[0].save
    @game.save
      if @game.save
        render json: @game
      else
        render json: @game.errors
      end
  end

  def update
    @game.do_init_second_player current_user
    @game.players[1].save
    @game.do_preparation_for_game
    save_game @game
    render json: @game
  end

  def put_card
    card = current_user.player.put_card(params[:rang], params[:suite])

    @game.get_card_from_player card, current_user.player, @game.attacker

    save_game @game

    @game.save
    if @game.game_ended?
      if @game.players[0].cards_count == 0
        @game.winner, @game.loser = @game.players[0], @game.players[1]
      else
        @game.winner, @game.loser = @game.players[1], @game.players[0]
      end
      @game.save
      end_game
    else
      render json: @game
    end
  end

  def end_turn
    @game.end_turn current_user.player
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
    @user1, @user2 = set_statistic

    puts "#########"
    puts @user1.games_count
    puts @user2.games_count

    @user1.save
    @user2.save

    @game.destroy

    render json: {status: "ended"}
  end

  private

  def set_game
    @game = Game.find(params[:id])
  rescue
    @game = nil
  end

  def set_user
    @user1 = User.find @game.players[0].user_id
    @user2 = User.find @game.players[1].user_id
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

    if @game.mover.user
      start_game_params = {
        game_mover: @game.mover.user.id,
        game_attacker: @game.attacker.user.id,
        game_defender: @game.defender.user.id,
        table_cards: @game.table.table_cards,
        player_cards: self.current_user.player.player_cards,
        deck_trump: @game.deck.deck_cards[35],
        cursor: @game.deck.cursor 
      }
      resp.merge! (start_game_params)
    end

    resp
  end
end