class Anthill
	attr_accessor :team, :food, :teamAnts, :teamRoom, :antCount
	def initialize team, roomType
		@team = team
		@roomType = roomType

		@food = 5
		@antCount = 0
		@teamRoom = []
		@teamAnts = []

		createRoom
	end

	def createRoom
		for i in 0...@roomType.length
			room = Room.new @team, @roomType[i]
			@teamRoom << room
		end
	end

	def createRuntimeRoom(team)
		room = Room.new team, @roomType[rand(3)]
		@teamRoom << room
	end
end