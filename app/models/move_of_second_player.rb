require "game_state"
require "move_of_first_player"

class MoveOfSecondPlayer < GameState

	def initialize _game
		super _game
	end
	def get_card_from_player _card, _player_id
		if @game.attacker == _player_id

			@game.set_game_state(MoveOfFirstPlayer.new @game)
			@game.do_get_card_from_player _card

			@game.attacker = @game.defender
			@game.defender = _player_id
		else
			@game.players[0].add_card _card
		end
	end
end
