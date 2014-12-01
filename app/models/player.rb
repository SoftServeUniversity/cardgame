class Player < ActiveRecord::Base

	serialize :player_cards, Array

	belongs_to :game
	belongs_to :user

 def put_card _card_id
  if self.cards_count > 0 
    card = self.player_cards.delete_at _card_id
    self.cards_count -= 1 
    card
  else
   puts 'Empty'
  end
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
