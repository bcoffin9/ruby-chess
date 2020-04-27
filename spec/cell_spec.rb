require 'spec_helper'

RSpec.describe ChessCell do
    let(:cell) { ChessCell.new("#{piece}", "#{color}", "a1") }

    context "created as a white cell with a rook" do
        let(:color) { "white" }
        let(:piece) { "rook" }

        it "and prints out with white background and pad" do
            allow(cell.piece).to receive(:img) {"rook"}
            expect(cell.to_s).to eq "rook".black.on_white
        end
    end

    context "created as an empty green cell" do
        let(:color) { "green" }
        let(:piece) { nil }

        it "prints out with green background and pad" do
            allow(cell.piece).to receive(:img) { nil }
            expect(cell.to_s).to eq "   ".black.on_green
        end
    end

    context ".address" do
        let(:color) { "green" }
        let(:piece) { "black" }

        it "returns address" do
            expect(cell.address).to eq "a1"
        end
    end
end