require 'rails_helper'

describe :move_of_second_player do
  before(:example) do
	@game = create(:game)
  	@game.do_init_first_player @user
    @game.do_init_second_player @user2
    @game.do_preparation_for_game
  end
  describe 'get_card_from_player' do
  	it "should find out access rights player " do
  	  output = capture(:stdout) do
      if @game.state == "move_of_first_player"
  	    @game.get_card_from_player(@game.players[0].player_cards[0], @game.players[0], @game.attacker)
  	  else
        @game.get_card_from_player(@game.players[1].player_cards[0], @game.players[1], @game.attacker)
      end
      end
  	  if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
  	  	expect(@game.state).to eq("move_of_second_player")
  	  	expect(@game.players[0].player_cards.length).to eq(5)
  	  	expect(output).to include "Access granted"
  	  elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
  	    expect(@game.state).to eq("move_of_first_player")
        expect(@game.players[1].player_cards.length).to eq(5)
        expect(output).to include "Access granted"
      else
      	expect(output).to include "Access denied"
  	  end
  	end
  end

  describe 'end_turn' do
  	it "should change state of game " do
  	@game.get_card_from_player(@game.players[0].player_cards[0], @game.players[0], @game.attacker)
    @game.get_card_from_player(@game.players[1].player_cards[0], @game.players[1], @game.attacker)
  	@game.end_turn @game.players[0]
  	  if @game.mover == @game.players[0]
  	  	if @game.players[0] == @game.attacker
  	  	  expect(@game.state).to eq("move_of_second_player")
  	  	else
  	  	  expect(@game.state).to eq("break_turn")
  	  	end
  	  end
  	end
  end
end