require_relative "piece.rb"

class Knight < Piece

    def initialize(color)
        img = color == "white" ? "\u2658" : "\u265e"
        moves = [
            [1,2],   # x y
            [2,1],
            [2,-1],
            [1,-2],
            [-1,-2],
            [-2,-1],
            [-2,1],
            [-1,2]
        ]
        super(color, img, "knight", moves, false)
        @castling = true
    end
end