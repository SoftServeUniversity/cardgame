require 'test_helper'
require 'rspec'

class DeckTest < ActiveSupport::TestCase
  before(:example) do
  	@deck = Deck.new
  end

  it "should build array of cards" do
  	@deck.init_cards
  	expect(@deck.deck_cards.length).to eq(36)
  end
end
