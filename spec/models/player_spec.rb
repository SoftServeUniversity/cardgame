require 'rails_helper'

describe Player do
  before(:example) do
  	@player = create(:player)
  	player_cards = []
  end

  it "should set the players hand 0" do
  	@player.init
  	expect(@player.cards_count).to eq(0)
  end

  it "should be able to receive card" do
  	@player.add_card (build(:card, suite:"clubs", rang: 5))
  	expect(@player.player_cards.length).to eq(1)
  	expect(@player.cards_count).to eq(1)
    expect(@player.player_cards[0]).to be_kind_of(Card)
  end	
  
  it "should be able to put card" do
  	output = capture(:stdout) do
  	  @player.init
      @player.put_card(8,"hearts")
    end
    expect(output).to include 'Empty'
  	@player.add_card (build(:card, suite:"clubs", rang: 5))
  	@player.add_card (build(:card, suite:"hearts", rang: 2))
  	expect(@player.put_card(2,"hearts")).to_not eq(@player.put_card(5,"clubs"))
    expect(@player.put_card(2,"hearts")).to be_kind_of(Card)
  end

  it "should be able to delete card" do
  	card1 = build(:card, suite:"hearts", rang: 2)
  	card2 = build(:card, suite:"clubs", rang: 7)
  	@player.add_card(card2)
  	@player.add_card(card1)
  	@player.delete_card(card1)
  	expect(@player.player_cards.length).to eq(1)
  	expect(@player.cards_count).to eq(1)
  	expect(@player.player_cards[0]).to_not eq(card1)
  end		
end