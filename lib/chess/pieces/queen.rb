require_relative "piece.rb"

class Queen < Piece
    MOVES = [
        [-1,1], # up and right
        [0,1],  # right
        [1,1],  # down and right
        [1,0],  # down
        [1,-1], # down and left
        [0,-1], # left
        [-1,-1],# up and left
        [-1,0]  # up
    ]

    def initialize(color)
        img = color == "white" ? "\u2655" : "\u265b"
        super(color, img, "queen")
    end
end