require_relative 'piece.rb'

class Rook < Piece
	attr_accessor :face
	def initialize(board, color, loc)
		@rook_moved = false
		super
		if color == "white"
		@face = '♖'
		else
			@face = '♜'
		end
	end
	def possible_moves
		moves = []
		x = @loc[0]
		y = @loc[1]
		for direction in [[1,0], [0,1], [-1,0], [0,-1]]
			for i in 1..7
				final_x = x + i * direction[0]
				final_y = y + i * direction[1]
				if final_x <= 7 and final_y <= 7 and final_y >= 0 and final_x >= 0 and not @board[final_y][final_x]
					moves.push([final_x, final_y])
				else
					if final_x <= 7 and final_y <= 7 and final_y >= 0 and final_x >= 0 and not @board[final_y][final_x].color == @color
						moves.push([final_x,final_y])
					end
					break
				end
			end
		end
		return moves
	end

	def move(dest)
		@rook_moved = true
		super
	end
end
