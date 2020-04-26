class Piece
    attr_reader :color, :img, :name
    attr_accessor :alive
    
    def initialize(color, img, name)
        @color = color
        @img = img
        @name = name
        @alive = true
    end
    
end