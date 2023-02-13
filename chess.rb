require 'json'

require_relative 'check.rb'
require_relative 'pieces/pawn.rb'
require_relative 'pieces/rook.rb'
require_relative 'pieces/knight.rb'
require_relative 'pieces/bishop.rb'
require_relative 'pieces/queen.rb'
require_relative 'pieces/king.rb'

COLUMNS = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
ROWS = [1, 2, 3, 4, 5, 6, 7, 8]
PIECES = {R: Rook, N: Knight, B: Bishop, Q: Queen, K: King, P: Pawn}

class Chess
	attr_accessor :moves
	attr_accessor :board
	attr_accessor :whosup

	def initialize
		@moves = []
		@whosup = 'white'
		@board = Array.new(8) {Array.new(8)}
		Rook.new(board, "white", [0,0])
		Knight.new(board, "white", [1,0])
		Bishop.new(board, "white", [2,0])
		Queen.new(board, "white", [3,0])
		King.new(board, "white", [4,0])
		Bishop.new(board, "white", [5,0])
		Knight.new(board, "white", [6,0])
		Rook.new(board, "white", [7,0])

		Pawn.new(board, "white", [0,1])
		Pawn.new(board, "white", [1,1])
		Pawn.new(board, "white", [2,1])
		Pawn.new(board, "white", [3,1])
		Pawn.new(board, "white", [4,1])
		Pawn.new(board, "white", [5,1])
		Pawn.new(board, "white", [6,1])
		Pawn.new(board, "white", [7,1])
		Rook.new(board, "white", [0,0])

		Pawn.new(board, "black", [0,6])
		Pawn.new(board, "black", [1,6])
		Pawn.new(board, "black", [2,6])
		Pawn.new(board, "black", [3,6])
		Pawn.new(board, "black", [4,6])
		Pawn.new(board, "black", [5,6])
		Pawn.new(board, "black", [6,6])
		Pawn.new(board, "black", [7,6])

		Rook.new(board, "black", [0,7])
		Knight.new(board, "black", [1,7])
		Bishop.new(board, "black", [2,7])
		Queen.new(board, "black", [3,7])
		King.new(board, "black", [4,7])
		Bishop.new(board, "black", [5,7])
		Knight.new(board, "black", [6,7])
		Rook.new(board, "black", [7,7])
	end

	def save
		Dir.mkdir('saved') unless Dir.exist?('saved')
		i = 1
		while File.exist?("saved/game_" + "0" * (4 - i.to_s.length) + i.to_s + ".json")
			i += 1
		end
		name = "saved/game_" + "0" * (4 - i.to_s.length) + i.to_s + ".json"
		File.open(name, 'w') do |file|
			file.puts "{\"moves\": [\"#{@moves.join("\", \"")}\"]}"
		end
	end


	def print_board
		i = 8
		for row in board.reverse
			puts '  ' + '–' * 33
			print i.to_s + ' | '
			for piece in row
				if not piece
					print ' '
				else
					print piece.face
				end
				print ' | '
			end
			puts
			i -= 1
		end
		puts '  ' + '–' * 33
		print ' '
		for i in COLUMNS
			print '   ' + i.to_s
		end
		puts
	end

	def translate(notation)
		# Pawns
		# e4, exf5
		# Piece
		# Nf3, Nfd2 Nxc4
		# Qbd3, Qf1d3, Q5d3
		# Castle
		# O-O, O-O-O
		if notation == "O-O" or notation == "O-O-O"
			if @whosup == "white"
				if notation == "O-O"
					notation = "Kg1"
				else
					notation = "Kc1"
				end
			else 
				if notation == "O-O"
					notation = "Kg8"
				else
					notation = "Kc8"
				end
			end
		end


		if notation[0] == notation[0].downcase
			type = "P"
			selector = notation[0...-2].delete("x")
		else
			type = notation[0]
			selector = notation[1...-2].delete("x")
		end
		possibilities = []
		piece = PIECES[type.to_sym]
		final_x = COLUMNS.index(notation[-2])
		final_y = ROWS.index(notation[-1].to_i)
		for row in @board
			for spot in row
				if spot and spot.color == @whosup and spot.is_a?(piece) and spot.possible_moves.include?([final_x, final_y])
					possibilities.push(spot.loc)
				end
			end
		end
		if possibilities.length > 1
			x = nil
			y = nil
			if selector and COLUMNS.include?(selector[0])
				x = COLUMNS.index(selector[0])
			end
			if selector and ROWS.include?(selector[0].to_i)
				y = ROWS.index(selector[0].to_i)
			elsif selector and selector.length == 2 and ROWS.include?(selector[1].to_i)
				y = ROWS.index(selector[1].to_i)
			end
			
			for possibility in possibilities
				if (x and possibility[0] != x) or (y and possibility[1] != y)
					possibilities.delete(possibility)
				end
			end
		end
		if possibilities.length == 1
			return [possibilities[0], [final_x, final_y]]
		end
		return false
	end

	def make_move(notation)
		decoding = translate(notation)
		if not decoding
			return false
		end
		if in_check?(whosup, board, decoding[0], decoding[1])
			return false
		end
		@board[decoding[0][1]][decoding[0][0]].move(decoding[1])
		return true
	end

	def mated?(color)
		checkmated = in_check?(color, board)
		stalemated = (not checkmated)
		@board.each_with_index do |row, i|
			row.each_with_index do |piece, j|
				if piece and piece.color == color
					for move in piece.possible_moves
						if not in_check?(color, board, [i,j], move)
							checkmated = false
							stalemated = false
						end
					end
				end
			end
		end
		if checkmated
			return "checkmated"
		elsif stalemated
			return "stalemated"
		end
	end
	
end

if __FILE__ == $0
	game = Chess.new
	print "Put a number for the index of a saved game, otherwise put anything else: "
	i = gets.strip
	name = "saved/game_" + "0" * (4 - i.length) + i + ".json"
	puts  i == i.to_i.to_s 
	if i == i.to_i.to_s and File.exist?(name)
		file = File.read(name)
		data = JSON.parse(file)
		moves = data["moves"]
		puts "past moves:" + moves.join(", ")
		for move in moves
			game.make_move(move)
			game.moves.push(move)
			if game.whosup == "white"
				game.whosup = "black"
			else
				game.whosup = "white"
			end
		end
	end
	ended = false
	while not ended
		game.print_board
		puts game.whosup + " is up"
		while true
			print "make move: "
			move = gets.strip
			if move.length != 0
				if move == "save"
					game.save()
					ended = true
					break
				elsif game.make_move(move)
					game.moves.push(move)
					break
				end
			end
		end
		if game.whosup == "white"
			game.whosup = "black"
		else
			game.whosup = "white"
		end

		if game.mated?(game.whosup) == "checkmated"
			game.print_board
			if game.whosup == "white"
				puts "Black won!"
			else
				puts "White won!"
			end
			break
		elsif game.mated?(game.whosup) == "stalemated"
			game.print_board
			puts "Tie"
		end
	end
end



#add en passant later
#add castling
#add all draws