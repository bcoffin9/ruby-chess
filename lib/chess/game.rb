require_relative "./board.rb"
require_relative "./board_nav.rb"
require "pry"

class Game
    attr_reader :players
    attr_accessor :checkmate, :active_player, :board, :check

    include BoardNav

    def initialize
        @active_player = "white"
        @checkmate = false
        @check = false
        @en_passant = false
        @board = Board.new
    end

    public
    def welcome
        puts "Welcome to Chess"
        puts "We assume one of you know all the rules of chess"
        puts "To start a new game, enter \"1\""
        puts "To continue a saved game, enter \"2\""
        input = gets.chomp.to_i
        selection = game_selection(input)
        selection == "New" ? play : load_game
    end

    def play
        # at this point, we are beginning play
        # keep it simple, indicating whose move it is
        # reminder you can save the game if need be
        # or print out the moves
        while !@checkmate
            system "clear"
            @board.to_s
            puts "#{active_player}'s move"
            puts "Ex: \"b1 c3\" - move the piece at b1 to c3"
            begin
                move = gets.chomp.downcase
                save_game if move == "save"
                validate_move(move, @active_player)
            rescue => exception
                system "clear"
                @board.to_s
                puts exception.message
                puts "Try again #{@active_player}:"
                retry
            end
            @board.make_move(move)
            checkmate? ? @checkmate = true : switch_player
            check = true if check?
        end
        puts "Congratulations #{@active_player}"
        @board.to_s
    end

    def validate_move(move, player, shadow=false, shadow_cell=nil) # do not make the call to make move
        raise "that is not a valid move" if move.match(/^[a-h][1-8] [a-h][1-8]$/).nil?
        raise "player must be white or black" if !["black", "white"].include?(player)

        parsed_string = move.split(" ")
        from = parsed_string[0]
        to = parsed_string[1]
        from_cell = @board.get_cell(from)
        to_cell = @board.get_cell(to)

            
        raise "select one of your own pieces" if from_cell.piece.nil?
        raise "select one of your own pieces" if from_cell.piece.color != player

        if !to_cell.piece.nil?
            raise "one of your own pieces is on that square" if to_cell.piece.color == player
        end

        piece = from_cell.piece
        slider = piece.slider
        valid_move = false
        piece.moves.each do |move|
            break if valid_move
            current_cell = from_cell
            x, y = BoardNav.address_to_coord(current_cell.address)
            x_shift, y_shift = move

            loop do # do..while loop
                x += x_shift
                y += y_shift

                break if !BoardNav.on_board?(x, y) # if suggested move is off board

                if !slider # condition for while loop
                    if !shadow
                        valid_move = true if @board.ranks[y][x] == to_cell && validate_king_safety(from_cell) # holy shiiiit we made it!
                    else
                        valid_move = true if @board.ranks[y][x] == to_cell
                    end
                    break
                end
                
                if @board.ranks[y][x] == to_cell # to_cell has been reached
                    if !shadow
                        valid_move = true if validate_king_safety(from_cell) # does it expose the king?
                    else
                        valid_move = true # king has been exposed
                    end
                    break
                end

                if !shadow                                    # what will happen if we are not running validate king safety
                    break if !@board.ranks[y][x].piece.nil?   # there is a piece in the way
                else                                          # occurs when running validate_king_safety
                    break if !@board.ranks[y][x].piece.nil? && @board.ranks[y][x] != shadow_cell # allows shadow piece to move through from_cell
                end

            end
        end

        if !shadow
            raise "that piece cannot move to that square" if !valid_move # none of the directions got the to_cell
        else
            return valid_move # return true for validate_king_safety
        end 
    end

    def load_game
        system "clear"
        puts "Choose a game to load:"
        if Dir.empty?("saved_games")
            abort "No saved games"
        else
            saved_games = Dir.open("saved_games")
            names = []
            saved_games.each_child do |game|
                puts game
                names << game
            end
        end

        choice = gets.chomp
        begin
            raise "Please select a file, using the exact text you see" if names.find_index(choice) == nil
        rescue => exception
            puts exception.message
            choice = gets.chomp
            retry
        end
        marshal_game = File.open("saved_games/#{choice}","r")
        game_inception = Marshal.load(marshal_game)
        game_inception.play
    end

    def save_game
        system "clear"
        puts "Please name your game"
        begin
            filename = gets.chomp
            raise "That name already exists" if File.exists?("/saved_games/#{filename}.txt")
        rescue => exception
            puts exception.message
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
            raise "Please enter either a 1 or 2" if !((1..2).include?(input))
        rescue => exception
            puts exception.message
            input = gets.chomp.to_i
            retry
        else
            return input == 1 ? "New" : "Old"
        end
    end

    def switch_player
        @active_player = @active_player == "white" ? "black" : "white"
    end

    def validate_king_safety(from_cell) # used to see if move made exposes the king
        from_cell.piece.color == "white" ? opponent = "black" : opponent = "white"
        my_king_cell = @board.ranks.flatten.find { |cell| cell.piece != nil && cell.piece.name == "king" && cell.piece.color == from_cell.piece.color }

        opponent_cells = @board.ranks.flatten.find_all { |cell| cell.piece != nil && cell.piece.color == opponent }
        opponent_cells.each do |cell|
            move = "#{cell.address} #{my_king_cell.address}"
            begin
                return false if validate_move(move, opponent, true, from_cell) # if true, that means the king is exposed
            rescue => exception
                next
            end
        end
    end

    def check?
        false
    end

    def checkmate? # return boolean value, do not set the instance variable
        false
    end

end