require "spec_helper"

RSpec.describe BoardNav do

    context "#address_to_coord" do

        it "returns [0,0] when given a8" do
            expect(BoardNav.address_to_coord("a8")).to eq [0,0]
        end

        it "returns an empty array when given i1" do
            expect(BoardNav.address_to_coord("i1")).to eq []
        end

        it "returns an empty array when given a0" do
            expect(BoardNav.address_to_coord("a0")).to eq []
        end
    end
end