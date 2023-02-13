require_relative 'piece.rb'

class Knight < Piece
	attr_accessor :face
	def initialize(board, color, loc)
		super
		if color == "white"
			@face = '♘'
		else
			@face = '♞'
		end
	end
	def possible_moves
		moves = []
		x = @loc[0]
		y = @loc[1]
		for move in [[1,2], [2,1], [2,-1], [1,-2], [-1,-2], [-2,-1], [-2,1], [-1,2]]
			final_x = x + move[0]
			final_y = y + move[1]
			if final_x <= 7 and final_y <= 7 and final_y >= 0 and final_x >= 0 and (not @board[final_y][final_x] or not @board[final_y][final_x].color == @color)
				moves.push([final_x, final_y])
			end
		end
		return moves
	end
end

# board = Array.new(8) {Array.new(8)}
# knight_a = Knight.new(board, "white", [5,5])
# moves = knight_a.possible_moves

# y = 7
# for row in board.reverse
# 	puts '–' * 41
# 	print '| '
# 	x = 0
# 	for spot in row
# 		if not spot
# 			print ' '
# 		else
# 			print spot.face
# 		end
# 		if moves.include? [x,y]
# 			print '~'
# 		else
# 			print ' '
# 		end
# 		print ' | '
# 		x += 1
# 	end
# 	puts
# 	y -= 1
# end
# puts '–' * 41