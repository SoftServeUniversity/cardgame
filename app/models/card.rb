class Card

	attr_accessor :rang, :suite

	def initialize(suite = NIL, rang = NIL)
		@rang = rang
		@suite = suite
	end

end