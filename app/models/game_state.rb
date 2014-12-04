class GameState
	def initialize _game
		@game = _game
	end

	def init_player _user
		operation_is_not_allowed "init_player"
	end

	def prepare_game_to_start 
		operation_is_not_allowed "prepare_game_to_start"
	end

	def get_card_from_player _card, _player_id
		operation_is_not_allowed "get_card_from_player"
	end

	 def end_turn _player_id
	 	operation_is_not_allowed "end_turn"
	 end

	def operation_is_not_allowed operation_name
		puts "Oparation #{operation_name} is not allowed for Order's state #{@game.state_name}" 
	end
end