ns = File.read("input.txt").chomp.split(",").map(&:to_i)

fuels = []

for pos in ns.min..ns.max
	sum_fuel = 0
	for n in ns
		sum_fuel += (pos-n).abs
	end
	fuels << sum_fuel
end



puts "part1: #{fuels.min} (#{(ns.min..ns.max).to_a[fuels.index(fuels.min)]})"

seq = Enumerator.new do |y|
	a = b = 0
	loop do
		a += 1
		b += a
		y << b 
	end 
end

max_dist = 0
for pos in ns.min..ns.max
	for n in ns
		max_dist = (pos-n).abs if max_dist < (pos-n).abs
	end
end

full_seq = seq.take max_dist
fuels = []

for pos in ns.min..ns.max
	sum_fuel = 0
	for n in ns
		sum_fuel += full_seq[(pos-n).abs-1]
	end
	fuels << sum_fuel
end

puts "part2: #{fuels.min} (#{(ns.min..ns.max).to_a[fuels.index(fuels.min)]})"
