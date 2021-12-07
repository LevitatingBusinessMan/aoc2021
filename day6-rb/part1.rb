$fish = File.read("input.txt").chomp.split(",").map(&:to_i)
day = 0

def genday
	for i in 0..$fish.length-1
		remaining = $fish[i]
		if remaining != 0
			remaining += -1
			$fish[i] = remaining
		else
			remaining = 6
			$fish[i] = remaining
			$fish << 8
		end
	end
end

while day < 80
	#puts "After #{day} days: #{$fish.sort.join(",")}"
	genday
	day+=1
end

puts "part1: #{$fish.length}"
