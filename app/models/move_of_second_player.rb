require "game_state"
require "move_of_first_player"
require "break_turn"

class MoveOfSecondPlayer < GameState

  def initialize _game
    super _game
  end
  def get_card_from_player _card, _player_id
    if @game.mover.to_i == _player_id.to_i

      if @game.players[0].id.to_i == _player_id.to_i
        current_player = @game.players[0]
      else
        current_player = @game.players[1]
      end
      
      if @game.do_get_card_from_player _card, _player_id
        current_player.delete_card _card
        @game.set_game_state(MoveOfFirstPlayer.new @game)
        @game.mover = @game.players[0].id
      end
    else
      puts "Fatal ERROR"
    end
  end

  def end_turn _player_id
    puts "////////////////////END OF TURN in state"
    if @game.mover.to_i == _player_id.to_i
      if(_player_id.to_i == @game.attacker.to_i && @game.table.cards_count > 0) #END from attacker
        puts "///////////////ATTACKER END OF TURN in state"
        @game.set_game_state(MoveOfFirstPlayer.new @game)
        @game.do_end_turn
      elsif (_player_id.to_i == @game.defender.to_i) #END from defender
        puts "//////////////////DEFENDER END OF TURN in state"
        @game.set_game_state(BreakTurn.new @game)
        @game.mover = @game.attacker
        puts "//////////////////////////////////////////////////////BreakTurn"
        puts @game.state_name
        # @game.do_break_turn 1
      end
    end
  end
end