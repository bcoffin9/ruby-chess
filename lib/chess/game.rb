require_relative "./board.rb"
require_relative "./board_nav.rb"
require "pry"
require "colorize"

class Game
    WIDTH = 60
    PAD = "   "
    PRESIDENTS = [
        "William Clinton",
        "Abraham Lincoln",
        "Jimmy Carter",
        "Thomas Jefferson",
        "John Adams",
        "James Monroe",
        "Barack Obama",
        "Theodore Roosevelt"
    ]
    attr_reader :prez_name
    attr_accessor :checkmate, :active_player, :board, :check

    include BoardNav

    def initialize
        @active_player = "white"
        @checkmate = false
        @stalemate = false
        @check = false
        @board = Board.new
        @en_passant = nil
        @active_player_type = nil
        @prez_name = get_CPU
        @last_move = nil
    end

    public
    def welcome
        system "clear"
        puts "Welcome to Chess!".center(WIDTH)
        puts ""
        puts (PAD + "Play with your friend".ljust(30) + "-> Enter \"1\"").center(WIDTH)
        puts (PAD + "Play against #{@prez_name}".ljust(30) + "-> Enter \"2\"").center(WIDTH)
        puts ""
        puts (PAD + "To continue a saved game".ljust(30) + "-> Enter \"3\"").center(WIDTH)
        input = gets.chomp.to_i
        selection = game_selection(input)
        case selection
        when "New"
            play
        when "CPU"
            play_CPU
        when "Old"
            load_game
        end
    end

    def play
        while !@checkmate && !@stalemate
            system "clear"
            @board.to_s
            puts PAD + "Mr. #{@prez_name.split(" ")[1]} played #{@last_move}" if !@last_move.nil? && @active_player_type == "human"
            puts PAD + "#{active_player}'s move"
            puts PAD + "Ex: \"b1 c3\" \n   move the piece at b1 to c3" unless @check
            puts PAD + "CHECK!!".white.on_red if @check
            move = @active_player_type == "CPU" ? illicit_CPU_move : illicit_human_move
            
            @board.make_move(move_string: move, ep: @en_passant)
            set_en_passant(move)
            @last_move = move
            @check = check?
            @stalemate = stalemate?
            checkmate? ? @checkmate = true : switch_player
        end
        system "clear"
        @board.to_s
        puts PAD + "Congratulations #{@active_player}, you've claimed victory!".white.on_green if @checkmate
        puts PAD + "The game is a Draw".white.on_blue if @stalemate
    end

    def play_CPU
        system "clear"
        3.times { puts "" }
        puts PAD + "Would you like to play as black or white?"
        puts PAD + "White makes the first move in chess"
        begin
            choice = gets.chomp.downcase
            raise "Please choose either black or white" if !(["white", "black"].include?(choice))
        rescue => exception
            system "clear"
            3.times { puts "" }
            puts PAD + exception.message
            puts PAD + "White makes the first move in chess"
            retry
        end
        if choice == "white"
            @active_player_type = "human"
        else
            @active_player_type = "CPU"
        end
        play
    end

    def debug
        binding.pry
        self
    end

    def illicit_human_move
        begin
            move = gets.chomp.downcase
            save_game if move == "save"
            debug if move == "dbg"
            validate_move(move_string: move)
        rescue => exception
            system "clear"
            @board.to_s
            puts PAD + exception.message
            puts PAD + "Try again #{@active_player}:"
            puts PAD + "CHECK!!".white.on_red if @check
            retry
        end
        return move
    end

    def illicit_CPU_move # return a single string to serve as the move
        moves = []
        my_cells = @board.ranks.flatten.find_all { |cell| cell.piece != nil && cell.piece.color == @active_player }
        my_cells.each do |cell|
            moves << get_available_moves(cell)
        end
        return moves.flatten.sample
    end

    def validate_move(move_string:) # do not make the call to make move
        raise "that is not a valid move" if move_string.match(/^[a-h][1-8] [a-h][1-8]$/).nil?
        raise "player must be white or black" if !["black", "white"].include?(@active_player)

        parsed_string = move_string.split(" ")
        from = parsed_string[0]
        to = parsed_string[1]
        from_cell = @board.get_cell(from)
        to_cell = @board.get_cell(to)
            
        raise "select one of your own pieces" if from_cell.piece.nil? || from_cell.piece.color != @active_player
        raise "one of your own pieces is on that square" if !to_cell.piece.nil? && to_cell.piece.color == @active_player
        

        piece = from_cell.piece
        slider = piece.slider
        valid_move = false
        piece.moves.each do |move|
            return true if valid_move
            current_cell = from_cell
            x, y = BoardNav.address_to_coord(current_cell.address)
            x_shift, y_shift = move

            loop do # do..while loop
                x += x_shift
                y += y_shift

                break if !BoardNav.on_board?(x, y) # if suggested move is off board

                if !slider # condition for while loop
                    case from_cell.piece.name
                    when "king"
                        if x_shift.abs == 2
                            valid_move = true if @board.ranks[y][x] == to_cell && validate_castle(x_shift, from_cell) && !@check
                        else
                            valid_move = true if @board.ranks[y][x] == to_cell && validate_king_safety(from_cell, to_cell)
                        end
                    when "pawn"
                        valid_move = true if @board.ranks[y][x] == to_cell && validate_pawn_move(from_cell, x, y, x_shift, y_shift) && validate_king_safety(from_cell, to_cell)
                    else
                        valid_move = true if @board.ranks[y][x] == to_cell && validate_king_safety(from_cell, to_cell)
                    end
                    
                    break
                end
                
                if @board.ranks[y][x] == to_cell # to_cell has been reached
                    valid_move = true if validate_king_safety(from_cell, to_cell) # does it expose the king?
                    break
                end

                break if !@board.ranks[y][x].piece.nil? # we've 'run into' a piece on the way

            end
            return true if valid_move
        end

        raise "that piece cannot move to that square" if !valid_move # none of the directions got the to_cell
    end

    def load_game
        system "clear"
        puts PAD + "Please select a file by its corresponding number"
        if Dir.empty?("saved_games")
            abort "No saved games"
        else
            saved_games = Dir.open("saved_games")
            names = []
            index = 1
            saved_games.each_child do |game|
                puts PAD + "[#{index}]" + PAD + game
                names << game
                index += 1
            end
        end
        
        begin
            choice = Integer(gets.chomp)
            raise if !Integer(choice) || names[choice-1] == nil || choice < 1
        rescue => message
            system "clear"
            puts PAD + "Please select a file by its corresponding number"
            names = []
            index = 1
            saved_games.each_child do |game|
                puts PAD + "[#{index}]" + PAD + game
                names << game
                index += 1
            end
            puts PAD + "We didn't quite get that, please try again:"
            retry
        end
        marshal_game = File.open("saved_games/#{names[choice-1]}","r")
        game_inception = Marshal.load(marshal_game)
        game_inception.play
    end

    def save_game
        system "clear"
        puts PAD + "Please name your game"
        begin
            filename = gets.chomp
            raise "That name already exists" if File.exists?("/saved_games/#{filename}.txt")
        rescue => exception
            puts PAD + exception.message
            retry
        else
            saved_game = File.open("saved_games/#{filename}.txt", "w")
        end
        
        saved_game.puts(serialized_game = Marshal::dump(self))
        saved_game.close
        abort "Your game has been saved"
    end

    private

    def game_selection(input)
        begin
            raise "Please enter either a 1, 2, or 3" if !((1..3).include?(input))
        rescue => exception
            puts PAD + exception.message
            input = gets.chomp.to_i
            retry
        else
            case input
            when 1
                return "New"
            when 2
                return "CPU"
            when 3
                return "Old"
            end
        end
    end

    def get_CPU
        return PRESIDENTS.sample
    end

    def switch_player
        @active_player = @active_player == "white" ? "black" : "white"
        @active_player_type = @active_player_type == "CPU" ? "human" : "CPU" if !@active_player_type.nil?
    end

    def validate_king_safety(from_cell, to_cell) # false indicates the move is not valid
        temp_piece = to_cell.piece
        promoted_pawn = nil
        promoted_pawn = from_cell.piece if from_cell.piece.name == "pawn" && BoardNav.edge_rank?(to_cell.address)
        @board.make_sim_move(move_string:"#{from_cell.address} #{to_cell.address}", ep: @en_passant)
        switch_player
        
        check = !check? # do not call validate move

        @board.reset_sim_move(move_string:"#{to_cell.address} #{from_cell.address}", replace_piece: temp_piece, pawn: promoted_pawn)
        switch_player
        return check
    end

    def validate_pawn_move(from_cell, new_x, new_y, x_shift, y_shift) # return true for different conditions
        if x_shift.abs == 1 # making capture move
            return true if !@board.ranks[new_y][new_x].piece.nil?
            return true if @board.ranks[new_y][new_x] == @en_passant
        elsif [-2,-1,1,2].include?(y_shift) # moving straightforward
            return true if @board.ranks[new_y][new_x].piece.nil?
        end
        return false
    end

    def validate_castle(direction, from_cell) # return true if move is good
        #check for rook
        direction < 0 ? rook_address = "a" : rook_address = "h"
        direction < 0 ? step = -1 : step = 1
        from_cell.piece.color == "white" ? rook_address << "1" : rook_address << "8"
        rook_cell = @board.get_cell(rook_address)
        if rook_cell.piece.name == "rook" && rook_cell.piece.castle
            # check moves through to the cell
            2.times do |num|
                from_coord = BoardNav.address_to_coord(from_cell.address)
                x = from_coord[0]
                y = from_coord[1]
                num += 1
                step *= num
                x += step
                return false if !@board.ranks[y][x].piece.nil?
                to_address = BoardNav.coord_to_address([x, y])
                @board.make_sim_move(move_string: "#{from_cell.address} #{to_address}", ep: @en_passant)
                switch_player
                is_check = check?
                switch_player
                @board.reset_sim_move(move_string: "#{to_address} #{from_cell.address}", replace_piece:nil)
                return false if is_check
            end
            return true
        end
        return false
    end

    def set_en_passant(move_string) # check to see if pawn jump
        parsed_string = move_string.split(" ")
        from, to = parsed_string
        to_cell = @board.get_cell(to)
        from_coord = BoardNav.address_to_coord(from)
        to_coord = BoardNav.address_to_coord(to)
        if to_cell.piece.name == "pawn" && (from_coord[1] - to_coord[1]).abs == 2
            jump = (-1 * (from_coord[1] - to_coord[1]))/2
            y = to_coord[1] - jump
            x = to_coord[0]
            @en_passant = @board.ranks[y][x]
        else
            @en_passant = nil
        end
    end

    def check? # only need to know if the @active_player's piece can get to opp's king
        @active_player == "white" ? opponent = "black" : opponent = "white"
        opponent_king_cell = @board.ranks.flatten.find { |cell| cell.piece != nil && cell.piece.color == opponent && cell.piece.name == "king" }
        my_cells = @board.ranks.flatten.find_all { |cell| cell.piece != nil && cell.piece.color == @active_player }
        my_cells.each do |cell|
            return true if capture_move_list(cell).include?(opponent_king_cell.address)
        end

        false
    end

    def checkmate? # return boolean value, do not set the instance variable
        @active_player == "white" ? opponent = "black" : opponent = "white"
        switch_player
        opponent_cells = @board.ranks.flatten.find_all { |cell| cell.piece != nil && cell.piece.color == opponent }
        mate = true
        opponent_cells.each do |cell|
            if !get_available_moves(cell).empty?
                mate = false
                break
            end
        end
        switch_player
        return mate && @check
    end

    def stalemate? # only when player has no legal moves and is not in check
        @active_player == "white" ? opponent = "black" : opponent = "white"
        switch_player
        opponent_cells = @board.ranks.flatten.find_all { |cell| cell.piece != nil && cell.piece.color == opponent }
        stale = true
        opponent_cells.each do |cell|
            if !get_available_moves(cell).empty?
                stale = false
                break
            end
        end
        switch_player
        return stale && !@check

    end

    def capture_move_list(cell)
        from_coord = BoardNav.address_to_coord(cell.address)
        moves = []
        color = cell.piece.color

        cell.piece.moves.each do |move|
            x, y = from_coord
            x_shift, y_shift = move
            loop do
                x += x_shift
                y += y_shift
                break if !BoardNav.on_board?(x,y)
                if !cell.piece.slider
                    break if cell.piece.name == "king" && x_shift.abs == 2
                    break if cell.piece.name == "pawn" && x_shift.abs != 1
                    moves << @board.ranks[y][x].address if !@board.ranks[y][x].piece.nil? && @board.ranks[y][x].piece.color != color
                    break
                end

                if !@board.ranks[y][x].piece.nil?
                    moves << @board.ranks[y][x].address if @board.ranks[y][x].piece.color != color
                    break
                end
            
            end
        end
        return moves
    end

    def get_available_moves(cell) # return array of strings for CPU
        moves = []
        slider = cell.piece.slider

        cell.piece.moves.each do |move|
            x, y = BoardNav.address_to_coord(cell.address)
            x_shift, y_shift = move

            loop do # do..while loop
                x += x_shift
                y += y_shift

                break if !BoardNav.on_board?(x, y) # if proposed move is off board

                to_cell_address = BoardNav.coord_to_address([x,y])
                proposed_move = "#{cell.address} #{to_cell_address}"
                if !slider # condition for while loop
                    begin
                        moves << proposed_move if validate_move(move_string: proposed_move)
                    rescue => exception
                        break
                    ensure
                        break
                    end
                end

                begin
                    moves << proposed_move if validate_move(move_string: proposed_move)
                rescue => exception
                    break
                end
                break if !@board.ranks[y][x].piece.nil? && @board.ranks[y][x].piece.color == cell.piece.color
            end
        end
        
        return moves
    end

end