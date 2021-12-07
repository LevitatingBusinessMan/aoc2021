start_fish = File.read("input.txt").chomp.split(",").map(&:to_i)
DAYS=256

numbers = Array.new(9, 0)

for fish in start_fish
	numbers[fish] += 1
end

DAYS.times do
	nulls = numbers.shift
	numbers.push(nulls)
	numbers[6] += nulls
end

puts "part2: #{numbers.sum}"
