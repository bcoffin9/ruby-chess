require_relative "piece.rb"

class Queen < Piece

    def initialize(color)
        img = color == "white" ? "\u2655" : "\u265b"
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
        super(color, img, "queen", moves, true)
    end
end