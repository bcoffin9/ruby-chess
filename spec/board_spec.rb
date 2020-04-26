require "spec_helper"

RSpec.describe Board do
    let(:board) { Board.new }

    context "created" do

        it "has 8 ranks" do
            expect(board.ranks.length).to eq 8
        end

        it "each rank has 8 cells" do
            result = true
            board.ranks.each do |rank|
                result = false if rank.length != 8
            end
            expect(result).to be true
        end
    end
end