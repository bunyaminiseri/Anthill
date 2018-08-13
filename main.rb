require './Meadow.rb'
require './Anthill.rb'
require './Ant.rb'
require './Queen.rb'
require './Room.rb'
require './Cell.rb'

def main
	farm = Meadow.instance
	count = 4
	while count > 1
		
		
		farm.arrangeCells
		farm.placeFood
		farm.placeFood
		farm.placeFood
		farm.placeFood

		
		farm.checkToCreateRoom
		farm.createAnts
		farm.wander
		

		farm.checkForMevzu
		farm.checkForMama
		farm.checkForager
		farm.countAnthill
		farm.arrangeCells
		farm.displayGrid

		gets
	end
end

main