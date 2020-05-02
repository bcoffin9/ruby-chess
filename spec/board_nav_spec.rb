require "spec_helper"

RSpec.describe BoardNav do

    context "#address_to_coord" do

        it "returns [0,0] when given a8" do
            expect(BoardNav.address_to_coord("a8")).to eq [0,7]
        end

        it "returns an empty array when given i1" do
            expect(BoardNav.address_to_coord("i1")).to eq []
        end

        it "returns an empty array when given a0" do
            expect(BoardNav.address_to_coord("a0")).to eq []
        end
    end

    context "#on_board?" do
        
        it "returns false when x is out of bounds" do
            expect(BoardNav.on_board?(23,0)).to eq false
        end

        it "returns false when y is out of bounds" do
            expect(BoardNav.on_board?(4,-1)).to eq false
        end

        it "returns true when the given coord is on the board" do
            expect(BoardNav.on_board?(2,3)).to eq true
        end
    end
end