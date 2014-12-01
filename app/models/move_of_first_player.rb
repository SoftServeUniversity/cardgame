require "move_of_second_player"
require "game_state"

class MoveOfFirstPlayer < GameState

	def initialize _game
		super _game
	end
	def get_card_from_player _card, _player_id
		if @game.attacker == _player_id

			@game.set_game_state(MoveOfSecondPlayer.new @game)
			@game.do_get_card_from_player _card

			@game.attacker = @game.defender
			@game.defender = _player_id
		else
			@game.players[1].add_card _card
		end
	end
end
