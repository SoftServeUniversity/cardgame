require "card"
class Deck < ActiveRecord::Base
	serialize :deck_cards, Array

	belongs_to :game

	def init_cards
  	self.cursor = 0
  	(0..8).each do |rang|
    	init_card_iteration rang
  	end
  	shuffle_deck
 	end

		def init_card_iteration rang
				deck_cards << Card.new('hearts', rang)
				deck_cards << Card.new('spades', rang)
				deck_cards << Card.new('diamonds', rang)
				deck_cards << Card.new('clubs', rang)
		end

		def shuffle_deck
			self.deck_cards.shuffle!
			find_trump
		end

		def find_trump
			self.trump = deck_cards[35].suite
		end

		def get_one
			if self.cursor <= 35 
				self.cursor += 1
				self.deck_cards[cursor - 1]
			else
			 puts 'Deck is empty'
			end
		end
end
