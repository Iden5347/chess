require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

def in_check?(color, board, orig = nil, dest = nil)
	move = orig and dest
	if move
		old = board[dest[1]][dest[0]]
		board[dest[1]][dest[0]] = board[orig[1]][orig[0]]
		board[orig[1]][orig[0]] = nil
	end
	i = 0
	for row in board
		j = 0
		for piece in row
			if piece and piece.color == color and piece.is_a?(King)
				king_loc = [j, i]
			end
			j += 1
		end
		i += 1
	end
	for row in board
		for piece in row
			if piece and piece.color != color and piece.possible_moves.include?(king_loc)
				if move
					board[orig[1]][orig[0]] = board[dest[1]][dest[0]]
					board[dest[1]][dest[0]] = old
				end
				return true
			end
		end
	end
	if move
		board[orig[1]][orig[0]] = board[dest[1]][dest[0]]
		board[dest[1]][dest[0]] = old
	end
	return false
end