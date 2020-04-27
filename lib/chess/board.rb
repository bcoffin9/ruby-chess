require_relative './pieces/bishop.rb'
require_relative './pieces/king.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/pawn.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/rook.rb'
require_relative "./cell.rb"

class Board
    FILES = (" a ".." h ").to_a
    RANKS = ("1".."8").to_a

    attr_accessor :ranks

    def initialize
        @ranks = Array.new(8) { Array.new(8) { ChessCell.new } }
        setup_board
    end

    def win?
    end

    def make_move(string)
    end

    def to_s # can just use puts board now
        puts "help | save"
        puts "  " + FILES.join("") + "  "
        8.times do |idx|
            idx = 8 - 1 - idx
            puts "#{RANKS[idx]} " + print_rank(@ranks[idx]) + " #{RANKS[idx]}"
        end
        puts "  " + FILES.join("") + "  "
    end

    private
    def setup_board
        @ranks.each_with_index do |rank, ind|
            rank.each_with_index do |cell, idx|
                cell.color = get_color(ind,idx)
                cell.address = get_address(ind, idx)
            end
        end

        set_first_rank
        set_second_rank
        set_seventh_rank
        set_eighth_rank
    end

    def get_color(rank, file)
        if rank + file == 0
            return "green"
        elsif (rank + file) % 2 == 1
            return "white"
        else
            return "green"
        end
    end

    def get_address(rank, file)
        FILES[file] + RANKS[rank]
    end

    def set_first_rank
        @ranks[0][0].piece = Rook.new("white")
        @ranks[0][1].piece = Knight.new("white")
        @ranks[0][2].piece = Bishop.new("white")
        @ranks[0][3].piece = Queen.new("white")
        @ranks[0][4].piece = King.new("white")
        @ranks[0][5].piece = Bishop.new("white")
        @ranks[0][6].piece = Knight.new("white")
        @ranks[0][7].piece = Rook.new("white")
    end

    def set_second_rank
        8.times do |num|
            @ranks[1][num].piece = Pawn.new("white")
        end
    end

    def set_seventh_rank
        8.times do |num|
            @ranks[6][num].piece = Pawn.new("black")
        end
    end

    def set_eighth_rank
        @ranks[7][0].piece = Rook.new("black")
        @ranks[7][1].piece = Knight.new("black")
        @ranks[7][2].piece = Bishop.new("black")
        @ranks[7][3].piece = Queen.new("black")
        @ranks[7][4].piece = King.new("black")
        @ranks[7][5].piece = Bishop.new("black")
        @ranks[7][6].piece = Knight.new("black")
        @ranks[7][7].piece = Rook.new("black")
    end

    def print_rank(rank)
        result = ""
        rank.each do |cell|
            result << cell.to_s
        end
        result
    end

end