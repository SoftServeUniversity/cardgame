require "card"
class Player < ActiveRecord::Base

  serialize :player_cards, Array

  belongs_to :game
  belongs_to :user

  def put_card rang, suite
    player_card = self.player_cards[0]
    if self.cards_count > 0
      self.player_cards.each do |card|
        if ((card.rang.to_f == rang.to_f) && (card.suite.to_s == suite.to_s))
          player_card = card
        end
      end
    else
      puts 'Empty'
    end
    player_card
  end

def delete_card player_card
    self.player_cards.each do |card|
      if ((card.rang.to_i == player_card.rang.to_i) && (card.suite.to_s == player_card.suite.to_s))

        puts self.player_cards.delete(card)
        self.cards_count -= 1
        puts "____________________________DELETED"
        break
      end
    end
  end

  def init
    if !self.cards_count
      self.cards_count = 0
    end
  end

  def add_card new_card
    puts "??????????????????? add_card"
    puts new_card.rang
    puts new_card.suite
    init
    self.player_cards.push new_card
    self.cards_count  += 1
  end
  def clear
    self.player_cards = []
  end
end
