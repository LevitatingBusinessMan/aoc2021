ROWLEN = 5
COLUMNLEN = 5

file = File.read("input.txt")

numbers_to_draw = file.split("\n")[0].split(",").map(&:to_i)

lines = file.split("\n")
lines.shift 2
lines.push ""

$boards = []
current_board = []
lines.each { |line|
	if line.empty?
		$boards << current_board
		current_board = []
		next
	end
	current_board.concat line.chomp.split(" ").map(&:to_i)
}

$first = false
$drawn = []
def finale board, number
	score = (board.filter {|x| !$drawn.include? x }).sum * number
	if $boards.length == 1
		puts "part2: #{score}"
	end
	$boards.delete_at $boards.find_index board if $boards.find_index board
	puts "part1: #{score}" if !$first
	$first = true
end

numbers_to_draw.each { |number|
	$drawn << number
	$boards.each { |board|
		for row in 0..ROWLEN-1
			finale board, number if board[row*ROWLEN..row*ROWLEN+ROWLEN-1].all? {|x| $drawn.include? x}
		end
		for column_i in 0..COLUMNLEN-1
			f_column = []
			for i in 0..COLUMNLEN-1 do f_column << board[column_i+ROWLEN*i] end
			finale board, number if f_column.all? {|x| $drawn.include? x}
		end
	}
}
