class Ant
	attr_accessor :antType, :team, :exp, :alive
	def initialize(team, type)
		@team = team
		@antType = type
		@exp = 1
		@alive = true
	end

	def killAnt
		@alive = false
	end
end