require 'rails_helper'

describe :new_game do
  before(:example) do
  	@game = create(:game)
    @user = create(:user)
  end

  it "should initialize player" do
  	@game.do_init_first_player @user
  	expect(@game.players[0]).to be_kind_of(Player)
  	expect(@game.players[0].user_id).to eq(@user.id)
	  expect(@game.state).to eq("expactation_second_player")
  end
end