class Room
	attr_accessor :roomType
	def initialize(team, type)
		@team = team
		@type = type
		@ant
	end

	def newAnt
		ant = Ant.new(@team, @type)
		@ant = ant
    end
end