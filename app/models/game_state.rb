class GameState
 def initialize game
  @game = game
 end

 def method_missing(operation_name, *args, &block)
  if %i{init_player prepare_game_to_start get_card_from_player end_turn show_results}.include?(operation_name)
   puts "Operation #{operation_name} is not allowed for #{@game.state_name}  state " 
  else
   super(operation_name, *args, &block)
  end
 end
end