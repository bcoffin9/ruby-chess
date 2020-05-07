require "spec_helper"

RSpec.describe Game do
    let(:game) { Game.new }

    context "making a move on clean board" do

        it "string must be 5 characters" do
            expect { game.validate_move(move_string:"a2b2") }.to raise_error(RuntimeError, "that is not a valid move")
        end
        
        it "does not let you select an opponent's piece" do
            game.active_player = "white"
            expect { game.validate_move(move_string:"a7 b7") }.to raise_error(RuntimeError, "select one of your own pieces")
        end
        
        it "does not let you move to a square with one of your pieces" do
            game.active_player = "white"
            expect { game.validate_move(move_string:"a1 a2") }.to raise_error(RuntimeError, "one of your own pieces is on that square")
        end
        
        it "raises error if the piece cannot be moved to the square" do
            
        end
    end
end

