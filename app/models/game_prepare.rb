require "move_of_first_player"
require "game_state"

class GamePrepare < GameState

  def initialize _game
    super _game
  end

  def prepare_game_to_start
    @game.do_preparation_for_game
    if @game.mover == @game.players[0]
      @game.set_game_state(MoveOfFirstPlayer.new @game)
    elsif @game.mover == @game.players[1]
      @game.set_game_state(MoveOfSecondPlayer.new @game)
    end
  end
end