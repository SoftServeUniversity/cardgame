class Card

	attr_accessor :rang, :suite

	def initialize (suite = nil , rang = nil )
		@rang = rang
		@suite = suite
	end

end