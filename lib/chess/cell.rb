class ChessCell
    require 'colorize'
    attr_accessor :piece, :color, :address

    def initialize(piece=nil, color=nil, address=nil)
        @piece = piece
        @color = color
        @address = address
    end

    def to_s
        return get_piece.on_white if @color == "white"
        return get_piece.on_green if @color == "green"
    end

    private

    def get_piece
        @piece.nil? ? "   " : @piece.img.black #need space for rendering
    end

end
