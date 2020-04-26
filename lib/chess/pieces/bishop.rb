require_relative "piece.rb"

class Bishop < Piece
    MOVES = [
        [-1,1], # up and right
        [1,1],  # down and right
        [1,-1], # down and left
        [-1,-1] # up and left
    ]

    def initialize(color)
        img = color == "white" ? "\u2657" : "\u265d"
        super(color, img, "bishop")
    end
end
