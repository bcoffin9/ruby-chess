require_relative "piece.rb"

class Knight < Piece
    MOVES = [
        [-1,2], # up and right
        [1,2],  # down and right
        [1,-2], # down and left
        [-1,-2] # up and left
    ]

    def initialize(color)
        img = color == "white" ? "\u2658" : "\u265e"
        super(color, img, "knight")
        @castling = true
    end
end