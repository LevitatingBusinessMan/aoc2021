lines = File.read("input.txt").split("\n").map {|l| /(\d+),(\d+) -> (\d+),(\d+)/.match(l).captures.map(&:to_i)}

lines_s = lines.filter {|l| l[0] == l[2] || l[1] == l[3]}

field = Array.new(1000) { Array.new(1000,0) }

def drawline(l , field)
	x1, y1, x2, y2 = l

	#vertical
	if x1 == x2
		for i in y1 < y2 ? y1..y2 : y2..y1
			field[i][x1] += 1
		end
		return
	end

	#horizontal
	if y1 == y2
		for i in x1 < x2 ? x1..x2 : x2..x1
			field[l[1]][i] += 1
		end
		return
	end

	#diagonal
	for i in 0..(x2-x1).abs
		x = x1 < x2 ? x1+i : x1-i
		y = y1 < y2 ? y1+i : y1-i
		field[y][x] += 1
	end
end

lines_s.each {|l| drawline(l,field)}

score1 = field.inject(0) {|acc,r|acc+=r.count{|e| e >= 2}}

puts "part1: #{score1}"

field = Array.new(1000) { Array.new(1000,0) }

lines.each {|l| drawline(l,field)}

# field.each {|r|puts r.join(" ").gsub("0", ".")}

score2 = field.inject(0) {|acc,r|acc+=r.count{|e| e >= 2}}

puts "part2: #{score2}"
