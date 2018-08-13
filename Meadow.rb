require 'singleton'
require 'rubygems'
require 'colorize'
require 'colorized_string'

class Meadow
    include Singleton
    attr_accessor :grid
    def initialize()
        @grid = Array.new(15) {Array.new(15)}

        fillGrid
        addQueen("red")
        addQueen("blue")
        addQueen("yellow")
        addQueen("green")

    end    

    def placeFood
        @grid[rand(@grid.length)][rand(@grid.length)].food += 1
    end

    def fillGrid
        #adds cells to the grid
        #randomly place food in the cell
        for i in 0...@grid.length
            for j in 0...@grid.length
                @grid[i][j] = Cell.new()
            end
        end
    end

    def addQueen(team)
        #anthill should first spawn queen(builder)
        queen = Queen.new.addTeam(team)
        option = rand(3)
        if option == 0
            anthill = queen.addOption.addOption.buildAnthill
        elsif option == 1
            anthill = queen.addOption.addOption.addOption.buildAnthill
        else
            anthill = queen.addOption.addOption.addOption.addOption.buildAnthill
        end
        tmp1 = rand(@grid.length)
        tmp2 = rand(@grid.length)
        @grid[tmp1][tmp2].hill = anthill
        #queen selects a cell to build her anthill
        #then creates the anthill, semi-unique ant factory algorithm
        #start 5 foods, 1 builder, 1 warrior, etc.
    end

    def createAnts
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].hill
                    for k in 0...@grid[i][j].hill.teamRoom.length
                        if @grid[i][j].hill.antCount < 15 and @grid[i][j].hill.food > 0
                            ant = @grid[i][j].hill.teamRoom[k].newAnt      
                            @grid[i][j].hill.antCount+=1
                            @grid[i][j].hill.food-=1
                            if ant.antType == 2
                                @grid[i][j].hill.teamAnts << ant
                            else
                                @grid[i][j].ants << ant
                            end
                        end
                    end
                end
            end
        end
    end

    def checkToCreateRoom
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].hill
                    for k in 0...@grid[i][j].hill.teamAnts.length
                        if @grid[i][j].hill.teamAnts[k].alive
                            if @grid[i][j].hill.food > 0
                                @grid[i][j].hill.createRuntimeRoom(@grid[i][j].hill.team)
                                @grid[i][j].hill.food -= 1
                                @grid[i][j].hill.teamAnts[k].killAnt
                                @grid[i][j].hill.antCount -= 1
                            end
                        end
                    end
                end
            end
        end
    end

    def checkForager
        hillArray = [false,false,false,false]
        hillArray2 = ["red","blue","green","yellow"]
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].ants
                   for k in 0...@grid[i][j].ants.length
                        if @grid[i][j].ants[k].alive and grid[i][j].ants[k].antType == 1
                            if grid[i][j].ants[k].team == "red"
                                hillArray[0]=true
                            elsif grid[i][j].ants[k].team == "blue"
                                hillArray[1]=true
                            elsif grid[i][j].ants[k].team == "green"
                                hillArray[2]=true
                            elsif grid[i][j].ants[k].team == "yellow"
                                hillArray[3]=true
                            end
                        end
                    end
                end
            end
        end
        for m in 0...@grid.length
            for n in 0...@grid.length
                for s in 0...hillArray.length
                    if hillArray[s] == false
                        if @grid[i][j].hill != nil
                            if @grid[i][j].hill.team == hillArray2[s]
                                @grid[i][j].hill = nil
                                for x in 0...@grid.length
                                    for y in 0...@grid.length
                                        if @grid[i][j].ants
                                            for k in 0...@grid[i][j].ants.length
                                                if @grid[i][j].ants[k].team == hillArray2[s]
                                                    @grid[i][j].ants[k].killAnt
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end 
        hillArray = [false,false,false,false]    
    end
    def wander
        directionsX = [1,-1,0,0]
        directionsY = [0,0,1,-1]
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].ants.length > 0
                    for k in 0...@grid[i][j].ants.length
                        if @grid[i][j].ants[k].alive
                            temp = rand(4)
                            if ((i+directionsX[temp]) > 0) and ((i+directionsX[temp]) < 15) and  ((j+directionsY[temp])) > 0 and ((j+directionsY[temp]) < 15)
                                @grid[i+directionsX[temp]][j+directionsY[temp]].ants << @grid[i][j].ants[k]
                                #@grid[i][j].ants[k].killAnt
                            end
                        end
                    end
                end
            end
        end
    end

    def arrangeCells
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].ants.length > 0
                    counter = 0
                    for k in 0...@grid[i][j].ants.length
                        if @grid[i][j].ants[k].alive == true
                            if k == counter
                                counter += 1
                            else
                                @grid[i][j].ants[counter] = @grid[i][j].ants[k]
                                @grid[i][j].ants[k].alive = false
                                counter += 1
                            end
                        end
                    end
                end
            end
        end
    end

    def checkForMevzu
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].ants.length > 1
                    if @grid[i][j].ants[0].alive and @grid[i][j].ants[1].alive
                        if (@grid[i][j].ants[0] != nil) or (@grid[i][j].ants[1] != nil)
                            if (@grid[i][j].ants[0].antType == 0) and (@grid[i][j].ants[1].antType == 0) #warrior vs. warrior
                                if @grid[i][j].ants[0].team != @grid[i][j].ants[1].team
                                    loser = fight(@grid[i][j].ants[0], @grid[i][j].ants[1])
                                    if loser == 1
                                        @grid[i][j].ants[0].killAnt
                                        teamD = @grid[i][j].ants[0].team
                                        for x in 0...15
                                            for y in 0...15
                                                if @grid[x][y].hill
                                                    if @grid[x][y].hill.team == teamD
                                                        @grid[x][y].hill.antCount -= 1
                                                        puts "Fight"
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        @grid[i][j].ants[1].killAnt
                                        teamD = @grid[i][j].ants[1].team
                                        for x in 0...15
                                            for y in 0...15
                                                if @grid[x][y].hill
                                                    if @grid[x][y].hill.team == teamD
                                                        @grid[x][y].hill.antCount -= 1
                                                        puts "Fight"
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            elsif (@grid[i][j].ants[0].antType == 0) and (@grid[i][j].ants[1].antType == 1) #warrior vs. forager
                                if @grid[i][j].ants[0].team != @grid[i][j].ants[1].team
                                    dice = rand(2)
                                    if dice == 0
                                        @grid[i][j].ants[1].killAnt
                                        teamD = @grid[i][j].ants[1].team
                                        for x in 0...15
                                            for y in 0...15
                                                if @grid[x][y].hill
                                                    if @grid[x][y].hill.team == teamD
                                                        @grid[x][y].hill.antCount -= 1
                                                        puts "Fight"
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            elsif (@grid[i][j].ants[0].antType == 1) and (@grid[i][j].ants[1].antType == 0) #forager vs warrior
                                if @grid[i][j].ants[0].team != @grid[i][j].ants[1].team
                                    dice = rand(2)
                                    if dice == 0
                                        @grid[i][j].ants[0].killAnt
                                        teamD = @grid[i][j].ants[0].team
                                        for x in 0...15
                                            for y in 0...15
                                                if @grid[x][y].hill
                                                    if @grid[x][y].hill.team == teamD
                                                        @grid[x][y].hill.antCount -= 1
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                if @grid[i][j].hill != nil
                    for h in 0...@grid[i][j].ants.length
                        if @grid[i][j].ants[h]
                            if @grid[i][j].ants[h].alive
                                if @grid[i][j].ants[h] != nil
                                    if @grid[i][j].ants[h].antType == 0 and @grid[i][j].ants[h].team != @grid[i][j].hill.team
                                        dice = rand(5)
                                        if dice == 0

                                            teamD = @grid[i][j].hill.team
                                            @grid[i][j].ants[h].exp += 5
                                            for m in 0...@grid.length
                                                for n in 0...@grid.length
                                                    for s in 0...@grid[i][j].ants.length
                                                        if @grid[i][j].ants[s] != nil
                                                            if @grid[i][j].ants[s].team == teamD
                                                                @grid[i][j].ants[s].killAnt
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            puts "#{@grid[i][j].hill.team} got destroyed"
                                            @grid[i][j].hill = nil
                                            
                                        else
                                            @grid[i][j].ants[h].killAnt
                                        end

                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    def fight(fighter1, fighter2)
        chance1 = rand(fighter1.exp)
        chance2 = rand(fighter2.exp)

        if chance1 > chance2
            fighter1.exp += 1
            return 2
        elsif chance1 < chance2
            fighter2.exp += 1
            return 1
        else #fighter1 has the home advantage because he came first :)
            fighter1.exp += 1
            return 2
        end
        
    end

    def checkForMama
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].ants.length > 0
                    for k in 0...@grid[i][j].ants.length
                        if @grid[i][j].ants[k]
                            if @grid[i][j].ants[k].alive
                                if @grid[i][j].ants[k].antType == 1
                                    if @grid[i][j].food > 0
                                        teamP = @grid[i][j].ants[k].team
                                        for m in 0...@grid.length
                                            for n in 0...@grid.length
                                                if @grid[i][j].hill
                                                    if @grid[i][j].hill.team == teamP
                                                        @grid[i][j].hill.food += @grid[i][j].ants[k].exp
                                                    end
                                                end
                                            end
                                        end
                                        @grid[i][j].ants[k].exp += 1
                                        @grid[i][j].food -= 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    def countAnthill
        count = 0
        
        redWarrior = 0
        blueWarrior = 0
        greenWarrior = 0
        yellowWarrior = 0

        redForager = 0
        blueForager = 0
        greenForager = 0
        yellowForager = 0

        redBuilder = 0
        blueBuilder = 0
        greenBuilder = 0
        yellowBuilder = 0

        forager = 0
        builder = 0
        for i in 0...@grid.length
            for j in 0...@grid.length
                if @grid[i][j].ants.length > 0
                    for x in 0...@grid[i][j].ants.length
                        if @grid[i][j].ants[x].alive
                            if @grid[i][j].ants[x].antType == 0
                                if @grid[i][j].ants[x].team == "red"
                                    redWarrior += 1
                                end
                                if @grid[i][j].ants[x].team == "blue"
                                    blueWarrior += 1
                                end 
                                if @grid[i][j].ants[x].team == "green"
                                    greenWarrior += 1
                                end 
                                if @grid[i][j].ants[x].team == "yellow"
                                    yellowWarrior += 1
                                end          
                            end
                            if @grid[i][j].ants[x].antType == 1
                                if @grid[i][j].ants[x].team == "red"
                                    redForager += 1
                                end
                                if @grid[i][j].ants[x].team == "blue"
                                    blueForager += 1
                                end 
                                if @grid[i][j].ants[x].team == "green"
                                    greenForager += 1
                                end 
                                if @grid[i][j].ants[x].team == "yellow"
                                    yellowForager += 1
                                end          
                            end
                        end
                    end
                end
            end
        end
        for i in 0...15
            for j in 0...15
                if @grid[i][j].hill
                    if @grid[i][j].hill.team == "red"
                        for a in 0...@grid[i][j].hill.teamAnts.length
                            if @grid[i][j].hill.teamAnts[a].alive == true
                                redBuilder += 1
                            end
                        end
                        print ColorizedString["Food: #{@grid[i][j].hill.food}"].colorize(:color =>:white,:background => :red)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :red)
                        print ColorizedString["Rooms: #{@grid[i][j].hill.teamRoom.length}"].colorize(:color =>:white,:background => :red)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :red)
                        print ColorizedString["Warrior: #{redWarrior}"].colorize(:color =>:white,:background => :red)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :red)
                        print ColorizedString["Forager: #{redForager}"].colorize(:color =>:white,:background => :red)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :red)
                        print ColorizedString["Builder: #{redBuilder}"].colorize(:color =>:white,:background => :red)
                    end
                    if @grid[i][j].hill.team == "blue"
                        for a in 0...@grid[i][j].hill.teamAnts.length
                            if @grid[i][j].hill.teamAnts[a].alive == true
                                blueBuilder += 1
                            end
                        end
                        print ColorizedString["Food: #{@grid[i][j].hill.food}"].colorize(:color =>:white,:background => :blue)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :blue)
                        print ColorizedString["Rooms: #{@grid[i][j].hill.teamRoom.length}"].colorize(:color =>:white,:background => :blue)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :blue)
                        print ColorizedString["Warrior: #{blueWarrior}"].colorize(:color =>:white,:background => :blue)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :blue)
                        print ColorizedString["Forager: #{blueForager}"].colorize(:color =>:white,:background => :blue)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :blue)
                        print ColorizedString["Builder: #{blueBuilder}"].colorize(:color =>:white,:background => :blue)
                    end
                    if @grid[i][j].hill.team == "green"
                        for a in 0...@grid[i][j].hill.teamAnts.length
                            if @grid[i][j].hill.teamAnts[a].alive == true
                                greenBuilder += 1
                            end
                        end
                        print ColorizedString["Food: #{@grid[i][j].hill.food}"].colorize(:color =>:white,:background => :green)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :green)
                        print ColorizedString["Rooms: #{@grid[i][j].hill.teamRoom.length}"].colorize(:color =>:white,:background => :green)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :green)
                        print ColorizedString["Warrior: #{greenWarrior}"].colorize(:color =>:white,:background => :green)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :green)
                        print ColorizedString["Forager: #{greenForager}"].colorize(:color =>:white,:background => :green)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :green)
                        print ColorizedString["Builder: #{greenBuilder}"].colorize(:color =>:white,:background => :green)
                    end
                    if @grid[i][j].hill.team == "yellow"
                        for a in 0...@grid[i][j].hill.teamAnts.length
                            if @grid[i][j].hill.teamAnts[a].alive == true
                                yellowBuilder += 1
                            end
                        end
                        print ColorizedString["Food: #{@grid[i][j].hill.food}"].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString["Rooms: #{@grid[i][j].hill.teamRoom.length}"].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString["Warrior: #{yellowWarrior}"].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString["Forager: #{yellowForager}"].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString[" || "].colorize(:color =>:white,:background => :yellow)
                        print ColorizedString["Builder: #{yellowBuilder}"].colorize(:color =>:white,:background => :yellow)
                    end
                    puts
                    count += 1
                end
            end
        end
    count
    end

    #def printAnts
    #    count = 0
    #    for i in 0...@grid.length
    #        for j in 0...@grid.length
    #            for k in 0...@grid[i][j].ants.length
    #                if @grid[i][j].ants[k].alive == true
    #                    count += 1
    #                end
    #            end
    #        end
    #    end
    #    count
    #end

    def displayGrid
        for i in 0...15
            for x in 0...15
                print ColorizedString["|         |"].colorize(:color =>:black,:background => :white)
            end
            puts
            for j in 0...15                  
                print ColorizedString["|"].colorize(:color =>:black,:background => :white)

                var = 0
                for h in 0...@grid[i][j].food
                    print ColorizedString["*"].colorize(:color =>:white,:background => :purple)
                    var += 1
                end
                for z in 0...@grid[i][j].ants.length
                    if @grid[i][j].ants[z].alive == true
                        var += 1
                    end
                end
                if @grid[i][j].hill
                    if @grid[i][j].hill.team == "red"
                        print ColorizedString["#"].colorize(:color =>:white,:background => :red)
                    end
                    if @grid[i][j].hill.team == "blue"
                        print ColorizedString["#"].colorize(:color =>:white,:background => :blue)
                    end
                    if @grid[i][j].hill.team == "green"
                        print ColorizedString["#"].colorize(:color =>:black,:background => :green)
                    end
                    if @grid[i][j].hill.team == "yellow"
                        print ColorizedString["#"].colorize(:color =>:black,:background => :yellow)
                    end
                    var += 1
                end
                if(var%2==0)
                    for l in 0...(9-var+1)/2
                        print ColorizedString["_"].colorize(:color =>:black,:background => :white)
                    end
                    for m in 0..@grid[i][j].ants.length-1
                        if @grid[i][j].ants[m].alive == true
                            if @grid[i][j].ants[m].antType==0
                                if @grid[i][j].ants[m].team == "red"
                                    print ColorizedString["^"].colorize(:color =>:white,:background => :red)
                                end
                                if @grid[i][j].ants[m].team == "blue"
                                    print ColorizedString["^"].colorize(:color =>:white,:background => :blue)
                                end
                                if @grid[i][j].ants[m].team == "green"
                                    print ColorizedString["^"].colorize(:color =>:black,:background => :green)
                                end
                                if @grid[i][j].ants[m].team == "yellow"
                                    print ColorizedString["^"].colorize(:color =>:black,:background => :yellow)
                                end
                            elsif @grid[i][j].ants[m].antType==1
                                if @grid[i][j].ants[m].team == "red"
                                    print ColorizedString["~"].colorize(:color =>:white,:background => :red)
                                end
                                if @grid[i][j].ants[m].team == "blue"
                                    print ColorizedString["~"].colorize(:color =>:white,:background => :blue)
                                end
                                if @grid[i][j].ants[m].team == "green"
                                    print ColorizedString["~"].colorize(:color =>:black,:background => :green)
                                end
                                if @grid[i][j].ants[m].team == "yellow"
                                    print ColorizedString["~"].colorize(:color =>:black,:background => :yellow)
                                end
                            else
                                print ColorizedString["_"].colorize(:color =>:black,:background => :white)
                            end
                        end
                    end
                    for n in 0...(9-var-1)/2
                        print ColorizedString["_"].colorize(:color =>:black,:background => :white)
                    end 
                else
                    for o in 0...(9-var)/2
                        print ColorizedString["_"].colorize(:color =>:black,:background => :white)
                    end
                    for r in 0...@grid[i][j].ants.length
                        if @grid[i][j].ants[r].alive == true
                            if @grid[i][j].ants[r].antType==0
                                if @grid[i][j].ants[r].team == "red"
                                    print ColorizedString["^"].colorize(:color =>:white,:background => :red)
                                end
                                if @grid[i][j].ants[r].team == "blue"
                                    print ColorizedString["^"].colorize(:color =>:white,:background => :blue)
                                end
                                if @grid[i][j].ants[r].team == "green"
                                    print ColorizedString["^"].colorize(:color =>:black,:background => :green)
                                end
                                if @grid[i][j].ants[r].team == "yellow"
                                    print ColorizedString["^"].colorize(:color =>:black,:background => :yellow)
                                end
                            elsif @grid[i][j].ants[r].antType==1
                                if @grid[i][j].ants[r].team == "red"
                                    print ColorizedString["~"].colorize(:color =>:white,:background => :red)
                                end
                                if @grid[i][j].ants[r].team == "blue"
                                    print ColorizedString["~"].colorize(:color =>:white,:background => :blue)
                                end
                                if @grid[i][j].ants[r].team == "green"
                                    print ColorizedString["~"].colorize(:color =>:black,:background => :green)
                                end
                                if @grid[i][j].ants[r].team == "yellow"
                                    print ColorizedString["~"].colorize(:color =>:black,:background => :yellow)
                                end
                            else
                                print ColorizedString["_"].colorize(:color =>:black,:background => :white)
                            end
                        end
                    end
                    for q in 0...(9-var)/2
                        print ColorizedString["_"].colorize(:color =>:black,:background => :white)
                    end
                end
                print ColorizedString["|"].colorize(:color =>:black,:background => :white)
            end
            puts
        end
    end
end