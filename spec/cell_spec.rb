require 'spec_helper'

RSpec.describe ChessCell do
    let(:cell) { ChessCell.new("#{piece}", "#{color}", "a1") }

    context "created as a black cell with a rook" do
        let(:color) { "black" }
        let(:piece) { "rook" }

        it "and prints out with black background and pad" do
            expect(cell.to_s).to eq "rook ".on_black
        end
    end

    context "created as an empty blue cell" do
        let(:color) { "blue" }
        let(:piece) { nil }

        it "prints out with blue background and pad" do
            expect(cell.to_s).to eq " ".on_blue
        end
    end

    context ".address" do
        let(:color) { "blue" }
        let(:piece) { "black" }

        it "returns address" do
            expect(cell.address).to eq "a1"
        end
    end
end