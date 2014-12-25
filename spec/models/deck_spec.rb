require 'rails_helper'

describe Deck do
  before(:example) do
  	@deck = create(:deck)
  	@deck.init_cards
  end
  it "should build array of cards" do
  	expect(@deck.deck_cards.length).to eq(36)
    @deck.deck_cards.each do |card|
      expect(card).to be_kind_of(Card)
    end
  end

  it "should find trump" do
  	expect(@deck.trump).to eq(@deck.deck_cards[35].suite)
  end

  it "should get one card" do
  	@deck.get_one
  	expect(@deck.cursor).to eq(1)
  	output = capture(:stdout) do
      answer = create(:deck)
      answer.init_cards
      answer.cursor = 36
      answer.get_one
    end
    expect(output).to include 'Deck is empty'
  end

  it "should be able to shuffle in init" do
  	@deck2 = create(:deck)
  	@deck2.init_cards
  	expect(@deck.deck_cards[35]).to_not eq(@deck2.deck_cards[35])
  	expect(@deck.deck_cards[0]).to_not eq(@deck2.deck_cards[0])
  end

  it "should init card iteration in init" do
  	@deck3 = create(:deck)
  	temp = Card.new('diamonds', 5)
  	@deck3.init_card_iteration 5
  	expect(@deck3.deck_cards[2].rang).to eq(temp.rang)
  	expect(@deck3.deck_cards[2].suite).to eq(temp.suite)
  end
end

