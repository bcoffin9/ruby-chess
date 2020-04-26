require_relative "piece.rb"

class Rook < Piece
    MOVES = [
        [0,1],  # right
        [1,0],  # down
        [0,-1], # left
        [-1,0]  # up
    ]

    attr_accessor :castling

    def initialize(color)
        img = color == "white" ? "\u2656" : "\u265c"
        super(color, img, "rook")
        @castling = true
    end

    def disable_castling
        @castling = false
    end

end