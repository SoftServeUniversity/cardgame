require 'rails_helper'

describe :expactation_second_player do
  before(:example) do
    @game = create(:game)
    @user = create(:user)
    @game.do_init_first_player @user
    @user2 = create(:user)
  end

  it "should initialize second player" do
  	@game.do_init_second_player @user2
  	expect(@game.players[1].user_id).to eq(@user2.id)
	  expect(@game.state).to eq("game_prepare")
  end
end