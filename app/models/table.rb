class Table < ActiveRecord::Base

	serialize :table_cards, Array

	belongs_to :game

	def put_cards
		cards = self.table_cards
		self.table_cards = []
		self.cards_count = 0
		cards
	end

	def add_card new_card
		self.table_cards.push new_card
		self.cards_count  += 1
	end
end
