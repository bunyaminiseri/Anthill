Bunyamin Iseri
Yalvac Top

**Press enter to run each cycle**

--main.rb--
In main we created a Meadow instance "farm" because it's Singleton and we want
to have only 1 Meadow. After that we assigned count to 4 (number of teams) and
started while loop until count is below 1 (only 1 team left). In every while loop
cyle, it calls placeFood (adds food to a random cell) 4 times, it checks if any 
anthill can create additional rooms wit "checkToCreateRoom", creates ants depending
on their room with "createAnts", moves all of these ants with "wander", checks if
there are any fight situations with "checkForMevzu", checks if any forager can 
grab a food with "checkForMama", counts total amount of anthills with "countAntHill"
and finally displays the grid after operation with "displayGrid".

--Meadow.rb--
Meadow class creates 15x15 array (grid) during it's initialization and fills every
element with Cell objects with fillGrid method. After that it calls addQueen method
4 times for 4 different teams.

addQueen: Creates Queen object, chooses options randomly which adds rooms to anthills
at different amount and creates Anthill object. Finally it chooses random x-y
coordinates and puts Anthill to that location.

createAnts: It search whole grid and finds if there is an Anthill on a cell. If
it finds an Anthill, it look for it's room array which holds all rooms with different
types. It checks if food and capacity (max 15) is enough. If both conditions are
true, it creates an Ant. If ant type is builder, it puts that ant to anthills array,
else it puts that ant to that cell's array.

checkToCreateRoom: It searches for all grid cells and if it finds a anthill in any
cell, it looks for that anthill's builder and food amount. If conditions are okay,
it creates a room for that anthill during runtime.

checkForager: An anthill should die if there are no foragers left for that anthill.
checkForager method searches for all grid cells and if it finds any forager, it 
makes that forager's team index true. After looking for all teams, in any team's 
index is still false after checking foragers, it kills all ants of that team and
deletes that team's Anthill. Finally it changes array to all false values to check again
in next cycle.

wander: This method is for moving all ants on grid. It has 2 coordinate arrays
directionsX and directionsY. It chooses a random index from these array and 
increases ant's coordinates depending on that values. To do this, it searches for
all grid cells' ant arrays and do all the steps for all ants in these arrays. These
steps are
-Pick a random index from 0 to 3
-Increase x coordinate depending on that random index
-Increase y coordinate dependin on same index (so it moves only up,down,left,right)
-Checks if these coordinates are still in the grid
-Add ant object to next cell's ant array
-Delete ant object from previous cell

arrangeCells: We do not delete ant objects from cell array because it causes array
index problems. Instead, we change ants' alive variable to false if they move any
other cell or if they die in a fight. This approach causes dead ants to stack up
at the beginning of the arrays. To avoid this, we wrote arrange cells method which looks
all cell arrays and moves alive ant to begginning of that cells's ant array.

checkForMevzu: This method is for checking if any two or more ants are on same cell
and making them fight with each other if they are on different teams. Also this method
check if a warrior comes on an anthill and making it attack to that anthill. First
it checks all cells and looks for that cell's length to skip if it's empty. After 
that it looks first 2 indexes if there are ants alive. Because fight is impossible
if there is one ant. After that it looks for 3 contditions:
1)Warrior-Warrior (It calls fight method which warriors have higher chance to win
depending on their experience)
2)Warrior-Forager (Forager has 50% chance to survive)
3)Forager-Warrior(Forager has 50% chance to survive)
After all fights finished, methods looks if there is any anthill on that cell. If
it finds anthill, first warrior in the array attacks that anthill with 20% of 
winning chance.

fight: fight method is used in checkForMevzu which takes 2 parameters and returns
the loser with a chance depending on their experience.

checkForMama: This method is for foragers to find and grab food in the grid. First
it checks for all cells' arrays ant looks for foragers (antType==1) in that cell.
If it finds a forager, it look for that cell's food variable if it is more than 0.
If it's true, forager grabs a food which increases that forager's anthill's food
variable depending on forager's experience. (For example if exp=2 food increases
by 2). Also it increases forager's exp by 1 when it grabs a food.

countAnthill: This method is for counting amount of anthills in the grid and
returning count value for while loop in main. Also this method is displaying information
about anthills. It counts all anthills in the grid and updates count value. Also 
when it finds an anthill, it gets that anthill's team and looks for all kind of ant
belongs to that anthill and updates the values. Finally it prints information
depending on their color.

displayGrid: This method is for displaying all information in the grid with color
values. Basically it looks for each cell's antArray ant prints alive ants in that 
arrays to corresponding cell. Ants colors changes depending on their team. Also 
it prints all food in that cell in purple color.
Bugs: When total amount of ants, foods and anthills in a cell is more than 9, it
may cause some corruptions in displaying.

--Cell.rb--
Cell class has only hill and food variables and ants arrays in initialize. These
cell objects fill each blocks in the grid.

--Queen.rb--
Queen is the builder class for anthill. addTeam method defines team of queen object
depending on it's parameter. addOption defines a roomType randomly and puts that 
integers to roomType array. In anthillClass rooms will be created depending on
this array. buildAnthill method creates and antHill same with queen's team and
it's roomType array.

--Anthill.rb--
Anthill class is for creating objects for different teams' anthills. Also this
creates rooms depending on their type with createRoom method at first. Also 
createRuntimeRoom creates rooms which has made by builder ants during it's runtime.

--Room.rb--
Every room object has team and type. Rooms only creates ants which has same type
with itself with newAnt method. Also it defines created ant's team.

--Ant.rb--
Ant class has team, type, exp and alive value for each individual ant object.
Team variable comes with queen -> anthill -> room -> ant order. antType comes 
from room object which has created that ant. exp can increase with actions of that
ant. alive value is looking if that ant is alive or not. alive value changes to
false with killAnt method which makes that ant uneffective in the grid.



