require_relative './pieces/bishop.rb'
require_relative './pieces/king.rb'
require_relative './pieces/knight.rb'
require_relative './pieces/pawn.rb'
require_relative './pieces/queen.rb'
require_relative './pieces/rook.rb'
require_relative "./cell.rb"
require_relative "./board_nav.rb"

class Board
    FILES = (" a ".." h ").to_a
    RANKS = ("1".."8").to_a

    attr_accessor :ranks

    include BoardNav

    def initialize
        @ranks = Array.new(8) { Array.new(8) { ChessCell.new } }
        setup_board
    end

    def make_move(move_string:, replace_piece: nil, pre_replace_piece: false, ep: nil)
        from, to = move_string.split(" ")
        from_cell = get_cell(from)
        to_cell = get_cell(to)

        if replace_piece.nil? # this is not a simulated move if true
            # remove pawn's first opener
            binding.pry if from_cell.piece.name == "pawn" && (from_cell.piece.moves.include?([0,2]) || from_cell.piece.moves.include?([0,-2]))
            if !pre_replace_piece
                from_cell.piece.moves.shift if from_cell.piece.name == "pawn" && (from_cell.piece.moves.include?([0,2]) || from_cell.piece.moves.include?([0,-2]))
            end

            # switch rooks castle boolean
            from_cell.piece.castle = false if from_cell.piece.name == "rook" && from_cell.piece.castle

            # remove king's castle moves if he moves and move rook if needed
            if from_cell.piece.name == "king" && (from_cell.piece.moves.include?([2,0]) || from_cell.piece.moves.include?([-2,0]))
                2.times { from_cell.piece.moves.shift }
                from_coord = BoardNav.address_to_coord(from_cell.address)
                to_coord = BoardNav.address_to_coord(to_cell.address)
                move_castle_rook(from_cell, to_cell) if (from_coord[0] - to_coord[0]).abs == 2
            end

            if !to_cell.piece.nil? # switch captured piece's boolean
                to_cell.piece.alive = false
            end
        end

        # remove en_passant capture
        if !ep.nil?
            en_passant_capture(to_cell) if en_passant_capture?(from_cell, to_cell)
        end

        to_cell.piece = from_cell.piece
        from_cell.piece = nil

        # promotion
        promote_pawn(to_cell) if to_cell.piece.name == "pawn" && BoardNav.edge_rank?(to_cell.address)

        if !replace_piece.nil? && replace_piece != "validate_castle"
            replace_piece.alive = true
            from_cell.piece = replace_piece
        end
    end

    def get_cell(address) #used in validate_move in game class
        @ranks.flatten.find { |item| item.address == address }
    end

    def to_s # can just use puts board now
        puts "save anytime by typing \"save\""
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

    def get_color(rank, file) #used in board generation
        if rank + file == 0
            return "green"
        elsif (rank + file) % 2 == 1
            return "white"
        else
            return "green"
        end
    end

    def get_address(rank, file) #used in board generation
        FILES[file].strip + RANKS[rank].strip
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

    def en_passant_capture?(from_cell, to_cell)
        from_coord = BoardNav.address_to_coord(from_cell.address)
        to_coord = BoardNav.address_to_coord(to_cell.address)
        (from_coord[0] - to_coord[0] != 0 && from_cell.piece.name == "pawn") ? result = true : result = false
        return result
    end

    def en_passant_capture(to_cell)
        to_coord = BoardNav.address_to_coord(to_cell.address)
        x = to_coord[0]
        y = to_coord[1]
        y == 5 ? capture_shift = -1 : capture_shift = 1
        y += capture_shift
        @ranks[y][x].piece.alive = false
        @ranks[y][x].piece = nil
    end

    def move_castle_rook(from_cell, to_cell)
        from_cell.address.split("").first < to_cell.address.split("").first ? rook_to_address = "f" : rook_to_address = "d"
        from_cell.piece.color == "white" ? rook_to_address << "1" : rook_to_address << "8"
        case rook_to_address
        when "d1"
            rook_from_address = "a1"
        when "f1"
            rook_from_address = "h1"
        when "d8"
            rook_from_address = "a8"
        when "f8"
            rook_from_address = "h8"
        else
            rook_from_address = nil
        end

        rook_from_cell = get_cell(rook_from_address)
        rook_to_cell = get_cell(rook_to_address)
        rook_to_cell.piece = rook_from_cell.piece
        rook_from_cell.piece = nil
        rook_to_cell.piece.castle = false
    end

    def promote_pawn(pawn_cell)
        color = pawn_cell.piece.color
        system "clear"
        self.to_s
        puts "What a big day for one of #{color}'s pawns"
        puts "He's getting promoted!!"
        puts "Choose a replacement"
        puts "\"r\" - Rook, \"n\" - kNight, \"b\" - Bishop, \"q\" - Queen"
        begin
            promotion = gets.chomp.downcase
            raise "That isn't an option" if promotion.match(/^[rnbq]$/).nil?
        rescue => exception
            system "clear"
            self.to_s
            puts "Try again"
            puts "\"r\" - Rook, \"n\" - kNight, \"b\" - Bishop, \"q\" - Queen"
            retry
        end
        pawn_cell.piece = nil
        case promotion
        when "r"
            pawn_cell.piece = Rook.new(color, false)
        when "n"
            pawn_cell.piece = Knight.new(color)
        when "b"
            pawn_cell.piece = Bishop.new(color)
        when "q"
            pawn_cell.piece = Queen.new(color)
        else
            pawn_cell.piece = Queen.new(color)
        end
    end
        
end