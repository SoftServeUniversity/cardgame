require 'rails_helper'

describe Player do
  before(:each) do
    @player = create(:player)
    player_cards = []
  end

  let(:add_card){ @player.add_card (build(:card, suite:SUITE_CLUBS, rang: NUMBER_FIVE)) }
  let(:add_card2){ @player.add_card (build(:card, suite: SUITE_HARTS, rang: NUMBER_TWO)) }

  it "should set the players hand to 0" do
    @player.init

    expect(@player.cards_count).to eq(NUMBER_ZERO)
  end

  it "should be able to receive card" do
    add_card

    expect(@player.player_cards.length).to eq(NUMBER_ONE)
  end
  it "should increase cards_count by 1"do
    add_card

    expect(@player.cards_count).to eq(NUMBER_ONE)
  end

  it "should add object of Card" do
    add_card

    expect(@player.player_cards[NUMBER_ZERO]).to be_kind_of(Card)
  end

  it "shouldn't be same result for different cards" do
    add_card
    add_card2

    expect(@player.put_card(NUMBER_TWO,SUITE_HARTS)).to_not eq(@player.put_card(NUMBER_FIVE, SUITE_CLUBS))
  end

  it "should be object of Card class" do
    add_card
    add_card2

    expect(@player.put_card(NUMBER_TWO,SUITE_HARTS)).to be_kind_of(Card)
  end
  describe "#delete_card" do
    before(:each) do
      @card1 = build(:card, suite:SUITE_HARTS, rang: NUMBER_TWO)
      card2 = build(:card, suite:SUITE_CLUBS, rang: NUMBER_SEVEN)
      @player.add_card(card2)
      @player.add_card(@card1)
      @player.delete_card(@card1)
    end

    it "should be able to delete card" do
      expect(@player.player_cards[NUMBER_ZERO]).to_not eq(@card1)
    end

    it "should remain one card " do
      expect(@player.player_cards.length).to eq(NUMBER_ONE)
    end

    it "should decrease cards_count by 1"do
      expect(@player.cards_count).to eq(NUMBER_ONE)
    end
  end
end
