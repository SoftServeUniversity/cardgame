require "game_prepare"
require "game_state"

class ExpectationOfSecondPlayer < GameState

	def initialize _game
		super _game
	end

	def init_player _user
		@game.do_init_second_player _user
		@game.set_game_state(GamePrepare.new @game)
	end
end