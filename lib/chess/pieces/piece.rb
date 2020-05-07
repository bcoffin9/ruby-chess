class Piece
    attr_reader :color, :img, :name, :slider, :gy_img
    attr_accessor :alive, :moves
    require "colorize"
    
    def initialize(color, img, name, moves=[], slider=true)
        @color = color
        @img = "#{img}".center(3)
        @gy_img = color == "white" ? "#{img}".center(4).black.on_white : "#{img}".center(4).black.on_white
        @name = name
        @alive = true
        @moves = moves
        @slider = slider
    end
    
end