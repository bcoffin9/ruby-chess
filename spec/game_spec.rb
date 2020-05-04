require "spec_helper"

RSpec.describe Game do
    let(:game) { Game.new }

    context "making a move on clean board" do

        it "string must be 5 characters" do
            expect { game.validate_move(move_string:"a2b2", player:"white") }.to raise_error(RuntimeError, "that is not a valid move")
        end
        
        it "requires white or black as a second parameter" do
            expect { game.validate_move(move_string:"a2 b6", player:"green") }.to raise_error(RuntimeError, "player must be white or black")
        end
        
        it "does not let you select an opponent's piece" do
            expect { game.validate_move(move_string:"a7 b7", player:"white") }.to raise_error(RuntimeError, "select one of your own pieces")
        end
        
        it "does not let you move to a square with one of your pieces" do
            expect { game.validate_move(move_string:"a1 a2", player:"white") }.to raise_error(RuntimeError, "one of your own pieces is on that square")
        end
        
        it "raises error if the piece cannot be moved to the square" do
            
        end
    end
end

