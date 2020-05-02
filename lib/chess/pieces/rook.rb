require_relative "piece.rb"

class Rook < Piece

    def initialize(color)
        img = color == "white" ? "\u2656" : "\u265c"
        moves = [
            [0,1],  # x y
            [1,0],
            [0,-1],
            [-1,0]
        ]
        super(color, img, "rook", moves, true)
    end

end