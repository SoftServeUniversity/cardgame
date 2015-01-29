# require 'rails_helper'

# describe GameState do
#   before(:example) do
# 	  @game = Game.new
#   	@game.init
#   	@game.init_state
#   	@card = Card.new('hearts', 5)
#   end

#   it "should miss prepare_game_to_start method" do
#   	output = capture(:stdout) do
#       answer = @game
#       answer.prepare_game_to_start
#     end
#   	expect(output).to include "Operation prepare_game_to_start is not allowed for #{@game.state_name}  state "
#   end

#   it "should miss get_card_from_player method" do
#   	output = capture(:stdout) do
#       answer = @game
#       answer.get_card_from_player @card, @game.players[0], @game.players[0]
#     end
#   	expect(output).to include "Operation get_card_from_player is not allowed for #{@game.state_name}  state "
#   end

#   it "should miss end_turn method" do
#   	output = capture(:stdout) do
#       answer = @game
#       answer.end_turn @game.players[1] 
#     end
#   	expect(output).to include "Operation end_turn is not allowed for #{@game.state_name}  state "
#   end

#   it "should miss show_results method" do
#   	output = capture(:stdout) do
#       answer = @game
#       answer.show_results
#     end
#   	expect(output).to include "Operation show_results is not allowed for #{@game.state_name}  state "
#   end

#   it "should miss init_player method" do
#   	@user = User.new(:email => "kichun@gmail.com",:password => "12qwaszx", :id => 5)
#     @user2 = User.new(:email => "kochun@gmail.com",:password => "12qwaszx", :id => 7)
#     @user3 = User.new(:email => "kuchun@gmail.com",:password => "12qwaszx", :id => 9)
#   	output = capture(:stdout) do
#       answer = @game
#       answer.init_player @user
#       answer.init_player @user2
#       answer.init_player @user3
#     end
#   	expect(output).to include "Operation init_player is not allowed for #{@game.state_name}  state "
#   end
# end