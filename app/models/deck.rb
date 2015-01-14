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
			%w{hearts aspades diamonds clubs}.each{|suite| deck_cards << Card.new(suite, rang)}
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
