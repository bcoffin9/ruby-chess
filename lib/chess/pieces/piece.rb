module Piece
    attr_reader :string, :alive
    
    def initialize(color)
        @color = color
        @string = "PIECE"
        @alive = true
    end
    
end