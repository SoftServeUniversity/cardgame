require "card"
class Deck < ActiveRecord::Base
  serialize :deck_cards, Array

  belongs_to :game

  def init_cards
    self.cursor = NUMBER_ZERO     
    (NUMBER_ZERO..NUMBER_EIGHT).each do |rang|
      init_card_iteration rang
    end
    shuffle_deck
  end

  def init_card_iteration rang
    %w{hearts aspades diamonds clubs}.each{|suite| deck_cards << Card.new(suite, rang)}
  end

  def shuffle_deck
    deck_cards.shuffle!
    find_trump
  end

  def find_trump
    self.trump = deck_cards[NUMBER_36 - NUMBER_ONE].suite
  end

  def get_one
    if cursor < NUMBER_36
      self.cursor += NUMBER_ONE
      deck_cards[cursor - NUMBER_ONE]
    else
      puts 'Deck is empty'
    end
  end
end
