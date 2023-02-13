require_relative 'piece.rb'

class King < Piece
	attr_accessor :face
	def initialize(board, color, loc)
		super
		if color == "white"
		@face = '♔'
		else
			@face = '♚'
		end
	end
	def possible_moves
		moves = []
		x = @loc[0]
		y = @loc[1]
		for move in [[1,-1], [1,0], [1,1], [0,1], [-1,1], [-1,0], [-1,-1], [0,-1]]
			final_x = x + move[0]
			final_y = y + move[1]
			if final_x <= 7 and final_y <= 7 and final_y >= 0 and final_x >= 0 and (not @board[final_y][final_x] or not @board[final_y][final_x].color == @color)
				moves.push([final_x, final_y])
			end
		end
		return moves
	end
	def move(dest)
		@king_moved = true
		super
	end
end
