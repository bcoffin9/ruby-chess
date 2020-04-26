require 'spec_helper'

RSpec.describe Bishop do
    context "white bishop" do
        piece = Bishop.new("white")
        it "is a white piece" do
            expect(piece.color).to eq "white"
        end

        it "is a bishop" do
            expect(piece.name).to eq "bishop"
        end

        it "has the white image" do
            expect(piece.img).to eq "\u2657"
        end
    end

    context "black bishop" do
        piece = Bishop.new("black")
        it "is a black piece" do
            expect(piece.color).to eq "black"
        end

        it "is a bishop" do
            expect(piece.name).to eq "bishop"
        end

        it "has the black image" do
            expect(piece.img).to eq "\u265d"
        end
    end
end

RSpec.describe King do
    context "white king" do
        piece = King.new("white")
        it "is a white piece" do
            expect(piece.color).to eq "white"
        end

        it "is a king" do
            expect(piece.name).to eq "king"
        end

        it "has the white image" do
            expect(piece.img).to eq "\u2654"
        end

        it "castling sequence is enabled" do
            expect(piece.castling).to be true
        end

        it "castling can be disabled" do
            piece.disable_castling
            expect(piece.castling).to_not be true
        end
    end

    context "black king" do
        piece = King.new("black")
        it "is a black piece" do
            expect(piece.color).to eq "black"
        end

        it "is a king" do
            expect(piece.name).to eq "king"
        end

        it "has the black image" do
            expect(piece.img).to eq "\u265a"
        end
    end
end

RSpec.describe Knight do
    context "white knight" do
        piece = Knight.new("white")
        it "is a white piece" do
            expect(piece.color).to eq "white"
        end

        it "is a knight" do
            expect(piece.name).to eq "knight"
        end

        it "has the white image" do
            expect(piece.img).to eq "\u2658"
        end
    end

    context "black knight" do
        piece = Knight.new("black")
        it "is a black piece" do
            expect(piece.color).to eq "black"
        end

        it "is a knight" do
            expect(piece.name).to eq "knight"
        end

        it "has the black image" do
            expect(piece.img).to eq "\u265e"
        end
    end
end

RSpec.describe Pawn do
    context "white pawn" do
        piece = Pawn.new("white")
        it "is a white piece" do
            expect(piece.color).to eq "white"
        end

        it "is a pawn" do
            expect(piece.name).to eq "pawn"
        end

        it "has the white image" do
            expect(piece.img).to eq "\u2659"
        end

        it "en passant sequence is enabled" do
            expect(piece.en_passant).to be true
        end

        it "en passant can be disabled" do
            piece.disable_en_passant
            expect(piece.en_passant).to_not be true
        end
    end

    context "black pawn" do
        piece = Pawn.new("black")
        it "is a black piece" do
            expect(piece.color).to eq "black"
        end

        it "is a pawn" do
            expect(piece.name).to eq "pawn"
        end

        it "has the black image" do
            expect(piece.img).to eq "\u265f"
        end
    end
end

RSpec.describe Queen do
    context "white queen" do
        piece = Queen.new("white")
        it "is a white piece" do
            expect(piece.color).to eq "white"
        end

        it "is a queen" do
            expect(piece.name).to eq "queen"
        end

        it "has the white image" do
            expect(piece.img).to eq "\u2655"
        end
    end

    context "black queen" do
        piece = Queen.new("black")
        it "is a black piece" do
            expect(piece.color).to eq "black"
        end

        it "is a queen" do
            expect(piece.name).to eq "queen"
        end

        it "has the black image" do
            expect(piece.img).to eq "\u265b"
        end
    end
end

RSpec.describe Rook do
    context "white rook" do
        piece = Rook.new("white")
        it "is a white piece" do
            expect(piece.color).to eq "white"
        end

        it "is a rook" do
            expect(piece.name).to eq "rook"
        end

        it "has the white image" do
            expect(piece.img).to eq "\u2656"
        end

        it "castling sequence is enabled" do
            expect(piece.castling).to be true
        end

        it "castling can be disabled" do
            piece.disable_castling
            expect(piece.castling).to_not be true
        end
    end

    context "black rook" do
        piece = Rook.new("black")
        it "is a black piece" do
            expect(piece.color).to eq "black"
        end

        it "is a rook" do
            expect(piece.name).to eq "rook"
        end

        it "has the black image" do
            expect(piece.img).to eq "\u265c"
        end
    end
end

RSpec.describe Piece do
    context "white piece" do
        piece = Piece.new("white", "img", "test")
        it "shows its name" do
            expect(piece.name).to eq "test"
        end

        it "shows its color" do
            expect(piece.color).to eq "white"
        end

        it "shows its image" do
            expect(piece.img).to eq "img"
        end
    end
end