require_relative "piece.rb"

class Pawn < Piece
    MOVES = 

    attr_accessor :en_passant
    def initialize(color)
        img = color == "white" ? "\u2659" : "\u265f"
        if color == "white"
            moves = [
                [0,2],  # first move up
                [1,1],  # up and right
                [0,1],  # up
                [-1,1], # up and left
            ]
        else
            moves = [
                [0,-2],  # first move down
                [-1,-1], # down and left
                [1,-1],  # down and right
                [0,-1]   # down
            ]
        end

        super(color, img, "pawn", moves, false)
    end

    def first_move
        moves.shift
    end
end