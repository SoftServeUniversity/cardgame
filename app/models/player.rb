require "card"
class Player < ActiveRecord::Base

  serialize :player_cards, Array

  belongs_to :game
  belongs_to :user

  def put_card rang, suite
    player_card = self.player_cards[NUMBER_ZERO]
    if cards_count > NUMBER_ZERO
      player_cards.each do |card|
        if cards_equality? card, rang, suite
          player_card = card
        end
      end
    else
      puts 'Empty'
    end
    player_card
  end

def delete_card player_card
    player_cards.each do |card|
      if cards_equality?(card, player_card.rang, player_card.suite)
        player_cards.delete(card)
        self.cards_count -= NUMBER_ONE
        break
      end
    end
  end

  def init
    if !cards_count
      self.cards_count = NUMBER_ZERO
    end
  end

  def add_card new_card
    init
    player_cards.push new_card
    self.cards_count  += NUMBER_ONE
  end

  def cards_equality? card, rang, suite
    (card.rang.to_f == rang.to_f) && (card.suite.to_s == suite.to_s)
  end
end
