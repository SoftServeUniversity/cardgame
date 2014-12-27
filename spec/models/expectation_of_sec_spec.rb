require 'rails_helper'

describe ExpectationOfSecondPlayer do
  before(:example) do
  	@game = Game.new
    @user = User.new(:email => "kichun@gmail.com",:password => "12qwaszx", :id => 5)
    @game.do_init_first_player @user
    @game.set_game_state(ExpectationOfSecondPlayer.new @game)
    @user2 = User.new(:email => "kochun@gmail.com",:password => "12qwaszx", :id => 7)
  end

  it "should initialize second player" do
  	@game.do_init_second_player @user2
  	expect(@game.players[1].user_id).to eq(@user2.id)
	  @game.set_game_state(GamePrepare.new @game)
	  expect(@game.state_name).to eq("GamePrepare")
  end
end