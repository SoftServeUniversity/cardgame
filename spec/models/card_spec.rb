require 'rails_helper'

describe Card do
  context "card had been initialized with params" do
    before(:each) do
      @card = build(:card, suite: SUITE_HARTS)
    end

    it "should initialize given suite" do
      expect(@card.suite).to eq(SUITE_HARTS)
    end

    it "should initialize given rank" do
      expect(@card.rang).to eq(NUMBER_FOUR)
    end
  end

  context "card created without params" do
    subject(:card){ @card = Card.new }

    it "should initialize rank to nil when
      not specified other" do
      expect(card.rang).to be_nil
    end

    it "should initialize suite to nil when
      not specified other" do
      expect(card.suite).to be_nil
    end
  end

end
