require_relative "./board.rb"

class Game
    attr_reader :players
    attr_accessor :checkmate, :active_player

    def initialize
        @active_player = "white"
        @checkmate = false
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
            puts "Ex: \"b1 c3\""
            begin
                move = gets.chomp.downcase
                process_move(move, @active_player)
            rescue => exception
                system "clear"
                @board.to_s
                puts exception.message
                puts "Try again:"
                retry
            end
            checkmate = true if @board.win?
            switch_player if !board.win?
        end
        puts "Congratulations #{@active_player}"
        puts @board
    end

    def load_game
        puts "Choose a game to load:"
        saved_games = Dir.open("/saved_games")
        names = []
        if saved_games.empty?
            abort "No saved games"
        else
            saved_games.each_child do |game|
                puts game
                names << game
            end
        end

        begin
            choice = gets.chomp
            raise "Please select a file, using the exact text you can see" if names.find_index(choice) == nil
        rescue => exception
            puts exception.message
            retry
        end
        marshal_game = File.open("/saved_games/#{choice}","r")
        game_inception = Marshal.load(marshal_game)
        game_inception.play
    end

    def save_game
        system "clear"
        puts "Please name your game"
        begin
            filename = gets.chomp
            raise "That name already exists" if File.exists?("saved_games/#{filename}.txt")
        rescue => exception
            puts exception.message
            retry
        else
            saved_game = File.open("/saved_games/#{filename}.txt", "w")
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

    def process_move(move)
        if move == "save"
            self.save_game
        else
            @board.make_move(move)
        end
    end

    def switch_player
        @active_player = @active_player == "white" ? "black" : "white"
    end

end