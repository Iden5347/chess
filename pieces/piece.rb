class Piece
	attr_accessor :color
	attr_accessor :loc
	def initialize(board, color, loc)
		@board = board
		@color = color
		@loc = loc
		board[loc[1]][loc[0]] = self
	end

	def move(dest)
		if possible_moves().include?(dest)
			@board[dest[1]][dest[0]] = self
			@board[loc[1]][loc[0]] = nil
			@loc = dest
			return true
		end
		return false
	end
end