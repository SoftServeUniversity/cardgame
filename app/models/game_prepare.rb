require "move_of_first_player"
require "game_state"

class GamePrepare < GameState

  def initialize _game
    super _game
  end

  def prepare_game_to_start
    @game.do_preparation_for_game
    if @game.mover.to_i == @game.players[0].id.to_i
      @game.set_game_state(MoveOfFirstPlayer.new @game)
    elsif @game.mover.to_i == @game.players[1].id.to_i
      @game.set_game_state(MoveOfSecondPlayer.new @game)
    end
  end
end