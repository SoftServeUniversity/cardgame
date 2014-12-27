require 'rails_helper'

describe NewGame do
  before(:example) do
  	@game = Game.new
    @user = User.new(:email => "kichun@gmail.com",:password => "12qwaszx", :id => 5)
  end

  it "should initialize player" do
  	@game.do_init_first_player @user
  	expect(@game.players[0].user_id).to eq(@user.id)
	  @game.set_game_state(ExpectationOfSecondPlayer.new @game)
	  expect(@game.state_name).to eq("ExpectationOfSecondPlayer")
  end
end