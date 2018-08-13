class Queen
    attr_accessor :anthill
    def initialize
        @team
        @roomType = []
    end

    def addTeam t
        @team = t
        self
    end

    def addOption
        @roomType << rand(3)
        self
    end

    def buildAnthill
        anthill = Anthill.new(@team, @roomType)
    end
end