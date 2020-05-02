require_relative "piece.rb"

class Pawn < Piece
    MOVES = 

    attr_accessor :en_passant
    def initialize(color)
        img = color == "white" ? "\u2659" : "\u265f"
        if color == "white"
            moves = [
                [-2,0], # first move up
                [-1,1], # up and right
                [-1,-1],# up and left
                [-1,0]  # up
            ]
        else
            moves = [
                [2,0],  #first move down
                [1,1],  # down and right
                [1,0],  # down
                [1,-1], # down and left
            ]
        end

        super(color, img, "pawn", moves, false)
    end

    def first_move
        moves.shift
    end
end