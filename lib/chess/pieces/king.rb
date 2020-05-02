require_relative "piece.rb"

class King < Piece
    attr_accessor :castling

    def initialize(color)
        img = color == "white" ? "\u2654" : "\u265a"
        moves = [
            [0,1],   # up
            [1,1],   # up and right
            [1,0],   # right
            [1,-1],  # down and right
            [0,-1],  # down
            [-1,-1], # down and left
            [-1,0],  # left
            [-1,1]   # up and left
        ]
        super(color, img, "king", moves, false)
        @castling = true
    end

    def disable_castling
        @castling = false
    end
end