class Player < ActiveRecord::Base

  serialize :player_cards, Array

  belongs_to :game
  belongs_to :user

 def put_card _rang, _suite
  card = self.player_cards[0]

  if self.cards_count > 0
    self.player_cards.each do |elem|
      if elem.rang.to_f == _rang.to_f && elem.suite.to_s == _suite.to_s
        card = self.player_cards.delete(elem)
      end
    end
    self.cards_count -= 1 
  else
   puts 'Empty'
  end
  card
 end

 def init
  if !self.cards_count
    self.cards_count = 0
  end
 end

 def add_card new_card
  init
  self.player_cards.push new_card
  self.cards_count  += 1
 end
end
