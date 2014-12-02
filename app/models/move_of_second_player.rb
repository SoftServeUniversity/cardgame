require "game_state"
require "move_of_first_player"

class MoveOfSecondPlayer < GameState

 def initialize _game
  super _game
 end
 def get_card_from_player _card, _player_id
  if @game.mover == _player_id

   if(@game.do_get_card_from_player(_card, _player_id))
    @game.players[1].delete_card _card
    @game.set_game_state(MoveOfFirstPlayer.new @game)
       @game.mover = @game.players[0].id
   end
  else
    puts "Fatal ERROR"
  end
 end
end