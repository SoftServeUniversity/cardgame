require 'rails_helper'

describe Player do
  before(:example) do
    @player = create(:player)
    player_cards = []
  end

  let(:add_card){ @player.add_card (build(:card, suite:"clubs", rang: 5)) }
  let(:add_card2){ @player.add_card (build(:card, suite:"hearts", rang: 2)) }

  it "should set the players hand to 0" do
    @player.init

    expect(@player.cards_count).to eq(0)
  end

  it "should be able to receive card" do
    add_card

    expect(@player.player_cards.length).to eq(1)
  end
  it "should increase cards_count by 1"do
    add_card

    expect(@player.cards_count).to eq(1)
  end

  it "should add object of Card" do
    add_card

    expect(@player.player_cards[0]).to be_kind_of(Card)
  end

  it "shouldn't be same result for different cards" do
    add_card
    add_card2

    expect(@player.put_card(2,"hearts")).to_not eq(@player.put_card(5,"clubs"))
  end

  it "should be object of Card class" do
    add_card
    add_card2

    expect(@player.put_card(2,"hearts")).to be_kind_of(Card)
  end
  describe "#delete_card" do
    before(:each) do
      @card1 = build(:card, suite:"hearts", rang: 2)
      card2 = build(:card, suite:"clubs", rang: 7)
      @player.add_card(card2)
      @player.add_card(@card1)
      @player.delete_card(@card1)
    end

    it "should be able to delete card" do
      expect(@player.player_cards[0]).to_not eq(@card1)
    end

    it "should remain one card " do
      expect(@player.player_cards.length).to eq(1)
    end

    it "should decrease cards_count by 1"do
      expect(@player.cards_count).to eq(1)
    end
  end
end
