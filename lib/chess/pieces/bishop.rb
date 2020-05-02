require_relative "piece.rb"

class Bishop < Piece

    def initialize(color)
        img = color == "white" ? "\u2657" : "\u265d"
        moves = [
            [1,1],   # up and right
            [1,-1],  # down and right
            [-1,-1], # down and left
            [-1,1]  # up and left
        ]
        super(color, img, "bishop", moves, true)
    end
end
