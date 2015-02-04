require 'rails_helper'
require 'pry'

describe Deck do

  before(:each) do
    @deck = create(:deck)
  end

  it "should have assosiation belongs_to Game" do
    g = Deck.reflect_on_association(:game)

    expect(g.macro).to eq(:belongs_to)
  end

  it "shouldn't have assosiation belongs_to Game" do
    g = Deck.reflect_on_association(:game)

    expect(g.macro).to_not  eq(:has_one)
  end

  it "should have Array deck_cards" do
    expect(@deck.deck_cards).to be_kind_of(Array)
  end

  describe "#init_cards" do

    it "should initialize cursor to nil and invoke
        card_itaration 9 times and shuffle_deck" do
      @deck.expects(:init_card_iteration).at_least(NUMBER_NINE)
      @deck.expects(:shuffle_deck)
      @deck.init_cards

      expect(@deck.cursor).to eq(NUMBER_ZERO)
    end

  end

  describe "#find_trump" do

    it "should define @deck.trump with last cards suite" do
      deck_card_init(NUMBER_35 , SUITE_CLUBS, NUMBER_TWO)
      @deck.find_trump

      expect(@deck.trump).to eq(@deck.deck_cards[NUMBER_35].suite)
    end

    it "should raise error if deck is empty" do  
      expect{ @deck.find_trump }.to raise_error(NoMethodError)
    end

  end

  describe "#get_one" do

    it "should get one card if cursor less than 36" do
      card = deck_card_init(NUMBER_35 , SUITE_CLUBS, NUMBER_TWO)
      @deck.cursor = NUMBER_35

      expect(@deck.get_one).to eq(card)
    end

    it "should return nil if cursor greater than NUMBER_35" do
      @deck.cursor = NUMBER_36

      expect(@deck.get_one).to be_nil
    end

  end

  describe "#shuffle_deck" do

    it "should invoke methods find_trump" do
      @deck.expects(:find_trump).once
      Array.stubs(:shuffle!).once

      @deck.shuffle_deck
    end
  end

  describe "#init_card_iteration" do
    before(:each) do
      @deck.init_card_iteration(NUMBER_THREE)
    end

    it "should init 4 cards in Array same rank" do
      @deck.deck_cards.each do |card|
        expect(card.rang).to eq(NUMBER_THREE)
      end
    end

    it "should have different suites for 4 cards" do
      i = NUMBER_ZERO
      %w{hearts aspades diamonds clubs}.each do |suite|
        expect(@deck.deck_cards[i].suite).to eq(suite)
        i += NUMBER_ONE
      end
    end

    it "should be an Array" do
      expect(@deck.init_card_iteration(NUMBER_THREE)).to be_kind_of(Array)
    end

  end
end
