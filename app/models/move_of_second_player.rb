require "game_state"
require "move_of_first_player"
require "break_turn"

class MoveOfSecondPlayer < GameState

  def initialize _game
    super _game
  end
  def get_card_from_player _card, _player, _attacker
    if @game.mover == _player

      if @game.players[0] == _player
        current_player = @game.players[0]
      else
        current_player = @game.players[1]
      end
      
      if @game.do_get_card_from_player _card, _player, _attacker
        current_player.delete_card _card
        @game.set_game_state(MoveOfFirstPlayer.new @game)
        @game.mover = @game.players[0]
      end
    else
      puts "Access denied"
    end
  end

  def end_turn _player
    puts "////////////////////END OF TURN in state"
    if @game.mover == _player
      if(_player == @game.attacker && @game.table.cards_count > 0) #END from attacker
        puts "///////////////ATTACKER END OF TURN in state"
        @game.set_game_state(MoveOfFirstPlayer.new @game)
        @game.do_end_turn
      elsif (_player == @game.defender) #END from defender
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