filename="input.txt"
if ARGV.length() > 0
	filename = ARGV[0]
end

file=File.open(filename)
contents=file.readlines.map(&:chomp)

for part in 1..2

	x=0
	y=0

	points=Array.new
	points.push([x, y])
	length=0
	for line in contents
	  	arr=line.split

		if part == 1
			dir=arr[0]
  			n=arr[1].to_i
		else
	  		dir=arr[2][7]
	  		n=arr[2][2..6].to_i(16)
		end

		length = length + n
		x2=x
		y2=y

	  	case dir
	  	when "R", "0"
			x2=x+n
	  	when "D", "1"
			y2=y+n
		when "L", "2"
			x2=x-n
		when "U", "3"
			y2=y-n
		end

		if x > x2
		  	minx=x2
		  	maxx=x
		else
			minx=x
		  	maxx=x2
		end

		if y > y2
		  	miny=y2
		  	maxy=y
		else
			miny=y
		  	maxy=y2
		end

		points.push([x2, y2])

		x=x2
		y=y2
	end

	# Adapted shoelace formula
	area=0
	for i in 1..(points.length() - 1)
	  area = area + points[i-1][0] * points[i][1]
	  area = area - points[i][0] * points[i-1][1]
	end

	if area < 0 
		area = - area
	end

	printf("Part %d : %d\n", part, length + (area-length)/2 + 1)
end