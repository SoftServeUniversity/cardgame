require 'rails_helper'

describe :game_prepare do
  before(:example) do
  	@game = create(:game)
    @user = create(:user)
    @game.do_init_first_player @user
    @user2 = create(:user)
    @game.do_init_second_player @user2
  end

  it "should do preparations" do
  	@game.do_preparation_for_game

  	expect(@game.table).to_not eq(nil)
  	expect(@game.table).to be_kind_of(Table)
  	expect(@game.deck).to_not eq(nil)
  	expect(@game.deck).to  be_kind_of(Deck)
    
  	if @game.mover == @game.players[0]
  	  expect(@game.state).to eq("move_of_first_player")
  	else
  	  expect(@game.state).to eq("move_of_second_player")
  	end
  end
end