class BreakTurn < GameState
	
	def initialize game
		super game
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
      end
    else
      puts "Access denied"
    end
  end

  def end_turn _player
    if @game.mover == _player
    	if(@game.players[0] == @game.mover)
    		player = 1
    	else
    		player = 0
    	end
    	@game.do_break_turn player
    end

     if @game.mover == @game.players[0]
      @game.set_game_state(MoveOfFirstPlayer.new @game)
    elsif @game.mover == @game.players[1]
      @game.set_game_state(MoveOfSecondPlayer.new @game)
    end
  end
end