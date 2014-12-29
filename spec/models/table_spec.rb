require 'rails_helper'

describe Table do
  before(:example) do
  	@game = create(:game)
    @user = create(:user)
    @user2 = create(:user)
    @game.do_init_first_player @user
  	@game.do_init_second_player @user2
  	@game.do_preparation_for_game
  end
  describe  "trump?" do
  	it "should compare for trump" do
  	  @game.players[0].player_cards.each do |card|
  	  	if card.suite == @game.deck.trump
  	  		expect(@game.table.trump? card).to eq(true)
  	  	end
  	  end
  	  @game.players[1].player_cards.each do |card|
  	  	if card.suite == @game.deck.trump
  	  		expect(@game.table.trump? card).to eq(true)
  	  	end
  	  end
  	end
  end

  describe  "table_empty?" do
  	it "should inspect table for emptyness" do
  	   expect(@game.table.table_empty?).to eq(true)
  	end
  end

  describe  "defend?" do
  	it "should return bool if player now defender" do
  	  if @game.defender == @game.mover
  	  	expect(@game.table.defend?).to eq(true)
  	  else
  	  	expect(@game.table.defend?).to eq(false)	
  	  end
  	end
  end

  describe  "attack?" do
  	it "should return bool if player now attacker" do
  	  if @game.attacker == @game.mover
  	  	expect(@game.table.attack?).to eq(true)
  	  else
  	  	expect(@game.table.attack?).to eq(false)	
  	  end
  	end
  end

  describe  "clear" do
  	it "should clear the table" do
  	  if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
  	  	@game.get_card_from_player(@game.players[1].player_cards[1], @game.players[1], @game.attacker ) 
      elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
      	@game.get_card_from_player(@game.players[0].player_cards[1], @game.players[0], @game.attacker) 
      end
      expect(@game.table.table_cards).to_not eq([])
      expect(@game.table.cards_count).to eq(1)
      @game.table.clear
      expect(@game.table.table_cards).to eq([])
      expect(@game.table.cards_count).to eq(0)
  	end
  end

  describe  "put_cards" do
  	it "should put_cards" do
  	  if @game.mover == @game.players[1] && @game.state == "move_of_second_player"
  	  	@card1 = @game.players[1].player_cards[1]
  	  	@game.get_card_from_player(@game.players[1].player_cards[1], @game.players[1], @game.attacker )
  	  	expect(@game.table.put_cards[0]).to eq(@card1)
      elsif @game.mover == @game.players[0] && @game.state == "move_of_first_player"
      	@card2 = @game.players[0].player_cards[1]
      	@game.get_card_from_player(@game.players[0].player_cards[1], @game.players[0], @game.attacker) 
      	expect(@game.table.put_cards[0]).to eq(@card2)
      end
  	end
  end
end