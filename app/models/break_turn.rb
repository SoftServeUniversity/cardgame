require "game_state"

class BreakTurn < GameState
	
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
      end
    else
      puts "Fatal ERROR"
    end
  end

  def end_turn _player_id
    if @game.mover.to_i == _player_id.to_i
    	if(@game.players[0].id == @game.mover.to_i)
    		player = 1
    	else
    		player = 0
    	end
    	@game.do_break_turn player
    end

     if @game.mover.to_i == @game.players[0].id.to_i
      @game.set_game_state(MoveOfFirstPlayer.new @game)
    elsif @game.mover.to_i == @game.players[1].id.to_i
      @game.set_game_state(MoveOfSecondPlayer.new @game)
    end
  end
end