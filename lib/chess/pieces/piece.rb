class Piece
    attr_reader :color, :img, :name, :slider
    attr_accessor :alive, :moves
    
    def initialize(color, img, name, moves=[], slider=true)
        @color = color
        @img = " #{img} "
        @name = name
        @alive = true
        @moves = moves
        @slider = slider
    end
    
end