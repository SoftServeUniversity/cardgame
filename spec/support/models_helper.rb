module ModelHelpers

  def deck_card_init(num , rang, suite)
    @deck.deck_cards[num] = build(:card, suite: suite, rang: rang)
  end

end

RSpec.configure do |config|
  config.include ModelHelpers, :type => :model
end