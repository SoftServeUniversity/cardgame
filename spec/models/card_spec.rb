require 'rails_helper'

describe Card do
  it "should initialize given params" do
  	@card = Card.new("hearts", 4)
  	expect(@card.suite).to eq("hearts")
  	expect(@card.rang).to eq(4)
  end
end