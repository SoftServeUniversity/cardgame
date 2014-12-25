require 'rails_helper'

describe MoveOfFirstPlayer do
  before(:example) do
	@game = Game.new
  	@game.init
  	@game.init_state
  	@game.init_player @user
    @game.init_player @user2
    @game.prepare_game_to_start
  end
  describe 'get_card_from_player' do
  	it "should find out access rights player " do
  	  output = capture(:stdout) do
      if @game.state_name == "MoveOfFirstPlayer"
  	    @game.get_card_from_player(@game.players[0].player_cards[0], @game.players[0], @game.attacker)
  	  else
        @game.get_card_from_player(@game.players[1].player_cards[0], @game.players[1], @game.attacker)
      end
      end
  	  if @game.mover == @game.players[1] && @game.state_name == "MoveOfSecondPlayer"
  	  	expect(@game.state_name).to eq("MoveOfSecondPlayer")
  	  	expect(@game.players[0].player_cards.length).to eq(5)
  	  	expect(output).to include "Access granted"
  	  elsif @game.mover == @game.players[0] && @game.state_name == "MoveOfFirstPlayer"
  	    expect(@game.state_name).to eq("MoveOfFirstPlayer")
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
  	@game.end_turn @game.players[0]
  	  if @game.mover == @game.players[0]
  	  	if @game.players[0] == @game.attacker
  	  	  expect(@game.state).to eq(MoveOfSecondPlayer)
  	  	else
  	  	  expect(@game.state).to eq(BreakTurn)
  	  	end
  	  end
  	end
  end
end