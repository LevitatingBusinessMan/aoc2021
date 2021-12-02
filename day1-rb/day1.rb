a=File.read("input.txt").split("\n").map(&:to_i)
b,c=0,0
for i in 0..1998
	b+=1 if a[i]<a[i+1]
	c+=1 if a[i]+a[i+1]+a[i+2]<a[i+1]+a[i+2]+a[i+3] if i < 1997
end
puts("part1: #{b}\npart2: #{c}")
