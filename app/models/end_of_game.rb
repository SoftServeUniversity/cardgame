require "game_state"
require "move_of_first_player"
require "move_of_second_player"

class EndOfGame < GameState
	
	def initialize _game
		super _game
	end

	def show_results
		if @game.mover == @game.players[0].id
			@winner = @game.players[1]
			@loser = @game.players[0]
		else
			@winner = @game.players[0]
			@loser = @game.players[1]
		end
	end
end