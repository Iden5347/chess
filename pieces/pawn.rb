require_relative 'piece.rb'

class Pawn < Piece
	attr_accessor :face
	def initialize(board, color, loc)
		super
		if color == "white"
			@face = '♙'
		else
			@face = '♟︎'
		end
	end
	def possible_moves
		d = 1 #direction
		home = 1 #resting position
		if color == "black"
			d = -1
			home = 6
		end
		moves = []
		x = @loc[0]
		y = @loc[1]
		for move in [[0,1 * d], [0,2 * d]]
			final_x = x + move[0]
			final_y = y + move[1]
			if final_x <= 7 and final_y <= 7 and final_y >= 0 and final_x >= 0 and \
			not @board[final_y][final_x] and \
			(move[1].abs == 1 or y == home)
				moves.push([final_x, final_y])
			else
				break
			end
		end
		for move in [[1,1 * d], [-1,1 * d]]
			final_x = x + move[0]
			final_y = y + move[1]
			if final_x <= 7 and final_y <= 7 and final_y >= 0 and final_x >= 0 and \
			@board[final_y][final_x] and not @board[final_y][final_x].color == @color
				moves.push([final_x, final_y])
			end
		end
		return moves
	end
end
