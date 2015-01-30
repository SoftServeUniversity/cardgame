require 'rails_helper'

describe Card do
	before(:each) do
		@card = build(:card, suite: "hearts")
  end

  it "should initialize given suite" do
  	expect(@card.suite).to eq("hearts")
  end

  it "should initialize given rank" do
  	expect(@card.rang).to eq(4)
  end

  subject(:card){ @card = Card.new }

  it "should initialize rank to nil when 
  		not specified other" do
  	expect(card.rang).to eq(nil)
  end

  it "should initialize suite to nil when
   		not specified other" do
  	expect(card.suite).to eq(nil)
  end

end