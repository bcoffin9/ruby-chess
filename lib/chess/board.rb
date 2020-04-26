require 'piece'

class Board
    FILES = ("a".."h").to_a
    RANKS = ("1".."8").to_a

    attr_accessor :ranks

    def initialize
        @ranks = Array.new(8) { Array.new(8) }
        fill_board
    end

    def win?
    end

    def make_move(string)
    end

    private
    def setup_board
        @ranks.each_with_index do |rank, index|
            rank.each_with_index do |cell, idx|
                color = get_color(index, idx)
                address = get_address(index, idx)
                piece = get_piece(address)
                cell = Cell.new(color, address)
            end
        end
    end

    def get_color(rank, file)
        if rank + file == 0
            return "blue"
        elsif (rank + file) % 2 == 1
            return "blue"
        else
            return "black"
        end
    end

    def get_address(rank, file)
        FILE[file] + RANK[rank]
    end

    def get_piece(address)
        #needs to return object, could be one of six pieces

    end

end