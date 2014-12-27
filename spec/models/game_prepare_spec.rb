# require 'rails_helper'

# describe GamePrepare do
#   before(:example) do
#   	@game = Game.new
#     @user = User.new(:email => "kichun@gmail.com",:password => "12qwaszx", :id => 5)
#     @game.do_init_first_player @user
#     @game.set_game_state(ExpectationOfSecondPlayer.new @game)
#     @user2 = User.new(:email => "kochun@gmail.com",:password => "12qwaszx", :id => 7)
#     @game.do_init_second_player @user2
#     @game.set_game_state(GamePrepare.new @game)
#   end

#   it "should do preparations" do
#   	@game.stub(do_preparation_for_game)
#   	expect(@game.table).to eq(@game.attacker)
# 	  @game.set_game_state(MoveOfFirstPlayer.new @game)
# 	  expect(@game.state_name).to eq("MoveOfFirstPlayer")
#   end
# end