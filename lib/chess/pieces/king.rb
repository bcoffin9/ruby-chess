require_relative "piece.rb"

class King < Piece
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

    attr_accessor :castling

    def initialize(color)
        img = color == "white" ? "\u2654" : "\u265a"
        super(color, img, "king")
        @castling = true
    end

    def disable_castling
        @castling = false
    end
end