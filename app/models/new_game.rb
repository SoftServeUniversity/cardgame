require 'game_state'
require 'expectation_of_second_player'

class NewGame < GameState
	
	def initialize _game
		super _game
	end

	def init_player _user
		@game.do_init_first_player _user
		@game.set_game_state(ExpectationOfSecondPlayer.new @game)
	end
end