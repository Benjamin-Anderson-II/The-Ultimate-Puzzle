#I rotated the stickers to have all of
#the pieces face the same direction		# LN: Good idea!

#pieces characteristics
=begin
	1: male out arrow					# LN: I'm not familiar with Ruby, but aren't there Enums? Would make this much more readable below
	2: male in arrow
	3: male octagon
	4: male cross
	5: female out arrow
	6: female in arrow
	7: female octagon
	8: female cross

	male out arrow => female in arrow
=end

#matching characteristics
=begin
	1-5		# LN: this is pretty clever to arrage them so that a difference of '4' can be used to determine compatibility.
	2-6
	3-7
	4-8
=end

PIECES = { #top, right, bottom, left, used
	1  => [1, 7, 6, 1, false],		# LN: as metioned above. Some kind of enum or hash would make this much easier to read (and troubleshoot)
	2  => [2, 6, 5, 3, false],		# LN: where possible try to avoid booleans, and use enums instead to make it clearer what the true / false actually means.
	3  => [2, 8, 6, 3, false],
	4  => [2, 7, 8, 3, false],
	5  => [2, 5, 8, 2, false],
	6  => [1, 5, 7, 2, false],
	7  => [3, 7, 5, 3, false],
	8  => [3, 7, 5, 1, false],
	9  => [1, 8, 6, 4, false],
	10 => [1, 5, 7, 4, false],
	11 => [2, 7, 8, 2, false],
	12 => [4, 5, 6, 2, false],
	13 => [4, 5, 5, 3, false],
	14 => [4, 8, 7, 3, false],
	15 => [3, 7, 8, 1, false],
	16 => [4, 6, 7, 3, false]
}

#where pieces are stored when they fit
LAYOUT = Array.new(4) {Array.new(4) {nil}}		# LN: should try to contain these fields within a class (as well as the corresponding methods below)

SOLUTIONS = [] #holds all solutions


#prints the solution as the keys that the pieces are in a 4x4 grid

def print_solution
	LAYOUT.each do |sub_array|
		sub_array.each do |piece|
			key = PIECES.key(piece)
			if key == nil or key < 10		# LN: should add a comment here to explain that this is for formatting (2 chars per number)
				print " #{key}, "
			else
				print "#{key}, "

			end
		end
		puts " "
	end
	puts ' '
end

#  LN: this is interesting. I would suggest NOT altering the pieces themselves. they should be treated as immutable.
#  LN: -> if the 'LAYOUT' array contained not just the piece, but also it's orientation, you wouldn't need to mutate pieces
def rotate(piece) # clockwise
	temp = piece.clone
	piece[0] = temp[1]
	piece[1] = temp[2]
	piece[2] = temp[3]
	piece[3] = temp[0]
end


#cleans up the is_possible function
def piece_fits(direction, piece1, piece2)
	if direction == 'left'
		if piece1[3] + 4 == piece2[1] or piece1[3] - 4 == piece2[1]
			return true
		end
	elsif direction == 'up'
		if piece1[0] + 4 == piece2[2] or piece1[0] - 4 == piece2[2]
			return true
		end
	end
end

#checks whether a piece would fit or not
def is_possible(row, col, piece)
	up_piece = nil
	left_piece = nil
	if row > 0 and row < 4
		up_piece = LAYOUT[row-1][col]
	end
	if col > 0 and col < 4
		left_piece = LAYOUT[row][col-1]
	end

	if (up_piece == nil or piece_fits('up', piece, up_piece)==true) and 
		(left_piece == nil or piece_fits('left', piece, left_piece)==true)
		return true
	end
	return false
end

#cleans up the puzzle function
def place_piece(row, col, piece)
	# LN: empty?
end

#main recursive function
def puzzle(row=0, col=0)
	if LAYOUT[3][3] != nil and !SOLUTIONS.include?(LAYOUT) # LN: again I'm not familiar, but does that 'include' function actually compare the array contents? That's unusual! I would have thought that it's just a reference comparison.
		SOLUTIONS.push(Marshal.load(Marshal.dump(LAYOUT)))
		print_solution
		return
	end

	PIECES.each do |key, piece|
		if piece[4]
			next
		end
		for i in 0...4			# LN: comment that this is for all orientations (because 'i' is never actually used in the loop)
			if is_possible(row, col, piece)
				if row < 4			# LN: what is the purpose of this check? wouldn't we ALWAYS add it to the layout if it's 'possible'
					LAYOUT[row][col] = piece
				end
					piece[4] = true
				if col == 3
					puzzle(row+1, 0)
				else
					puzzle(row, col+1)
				end
			end
			rotate(piece)
		end
	
		LAYOUT[row][col] = nil
		piece[4] = false
	end
	return
end

puzzle()
puts "#{SOLUTIONS.length}"