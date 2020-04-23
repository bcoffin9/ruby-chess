
class Game
    attr_reader :players
    attr_accessor :checkmate, :active_player

    def initialize(p1,p2)
        @players = { "White" => p1, "Black" => p2 }        @active_player = @players["White"]
        @checkmate = false
        # @board = Board.new
    end

    public
    def welcome
        puts "Welcome to Chess"
        puts "To start a new game, enter \"1\""
        puts "To continue a saved game, enter \"2\""
        selection = game_selection(gets.chomp.to_i)
        selection == "New" ? self.play : self.load_game
    end

    def play
        # at this point, we are beginning play
        # keep it simple, indicating whose move it is
        # reminder you can save the game if need be
        # or print out the moves
        while !@checkmate
            # system "clear"
            # @board.to_s
            # puts "${active_player.name}'s move"
            # move = gets.chomp
            # begin
            #   @board.make_move(active_player, move)
            # rescue => exception
            #   puts exception.message
            #   retry
            # end
            # checkmate = true if @board.win?
        end
        puts "Congratulations #{@active_player}"
        @board.moves.to_s
    end

    def load_game
        puts "Choose a game to load:"
        saved_games = Dir.open("saved_games")
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
        marshal_game = File.open("saved_games/#{choice}","r")
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
            saved_game = File.open("saved_games/#{filename}.txt", "w")
        end
        
        saved_game.puts(serialized_game = Marshal::dump(self))
        saved_game.close
        abort "Your game has been saved"
    end

    private
    def game_selection(input)
        begin
            input = gets.chomp.to_i
            raise "Please enter either a 1 or 2" if !((1..2).include?(input))
        rescue => exception
            puts exception.message
            retry
        else
            return input == 1 ? "New" : "Old"
        end
    end


end