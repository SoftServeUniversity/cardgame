class Deck < ActiveRecord::Base
	serialize :deck_cards, Array

	belongs_to :game

	# def initialize
	#   super
 #  	init_cards
	# end

	def init_cards
		self.cursor = 0
		for i in 0..8 do
				init_card_iteration i
			end
			shuffle_deck
		end

		def init_card_iteration i
				deck_cards << Card.new('hearts', i)
				deck_cards << Card.new('spades', i)
				deck_cards << Card.new('diamonds', i)
				deck_cards << Card.new('clubs', i)
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
			else puts 'Deck is empty'
			end
		end
end
