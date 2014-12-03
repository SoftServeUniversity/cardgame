require "move_of_second_player"
require "game_state"

class MoveOfFirstPlayer < GameState

 def initialize _game
  super _game
 end

 def get_card_from_player _card, _player_id
  puts"MoveOfFirstPlayer.get_card_from_player __________________________________"
  puts @game.mover
  puts _player_id
  if @game.mover.to_s == _player_id.to_s
    puts "HELLLLLLLLLLLLOOOOOOOOOOO OUTSIDE"

   if @game.do_get_card_from_player _card, _player_id 
    puts "HELLLLLLLLLLLLOOOOOOOOOOO INSIDE"

    @game.players[0].delete_card _card
    @game.set_game_state(MoveOfSecondPlayer.new @game)
    @game.mover = @game.players[1].id
   end
  else
   puts "Fatal ERROR"
  end
 end

end