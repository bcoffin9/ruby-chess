require "chess/version"
require_relative "./chess/cell.rb"
require_relative "./chess/board.rb"
require_relative "./chess/board_nav.rb"
require_relative "./chess/game.rb"
require_relative "./chess/pieces/piece.rb"
require_relative "./chess/pieces/bishop.rb"
require_relative "./chess/pieces/king.rb"
require_relative "./chess/pieces/pawn.rb"
require_relative "./chess/pieces/queen.rb"
require_relative "./chess/pieces/rook.rb"

module Chess
  class Error < StandardError; end
  # Your code goes here...
end
