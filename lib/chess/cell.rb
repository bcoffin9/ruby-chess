class ChessCell
    require 'colorize'
    attr_writer :piece
    attr_reader :color, :address

    def initialize(piece = nil, color, address)
        @piece = piece
        @color = color
        @address = address
    end

    def to_s
        return get_piece.on_black if @color == "black"
        return get_piece.on_blue if @color == "blue"
    end

    private

    def get_piece
        @piece.nil? ? "  " : @piece + " " #need space for rendering
    end

end
