require_relative "piece.rb"

class Pawn < Piece
    MOVES = [
        [-1,1], # up and right
        [1,1],  # down and right
        [1,0],  # down
        [1,-1], # down and left
        [-1,-1],# up and left
        [-1,0]
    ]

    attr_accessor :en_passant
    def initialize(color)
        img = color == "white" ? "\u2659" : "\u265f"
        super(color, img, "pawn")
        @en_passant = true
    end

    def disable_en_passant
        @en_passant = false
    end
end