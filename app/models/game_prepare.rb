require "move_of_first_player"
require "game_state"

class GamePrepare < GameState

 def initialize _game
  super _game
 end

 def prepare_game_to_start
  @game.do_preparation_for_game
  @game.set_game_state(MoveOfFirstPlayer.new @game)
  @game.mover = @game.players[0].id
  @game.attacker = @game.players[0].id
  @game.defender = @game.players[1].id
 end
end