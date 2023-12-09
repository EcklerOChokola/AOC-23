filename = "input.txt"
if (length(ARGS) >= 1)
	filename = ARGS[1]
end

open(filename) do f
	part1 = 0
	part2 = 0
	while ! eof(f)
		str = readline(f)
		strings = split(str)
		vector = map((x) -> parse(Int64, x), strings)
		factor = 1
		while ! reduce(&, map((x) -> x == 0, vector))
			part2 += factor * vector[1]
			factor *= -1
			for i in eachindex(vector)
				if (i != 1)
					vector[i-1] = vector[i] - vector[i-1]
				end
			end
			part1 += pop!(vector)
		end
	end
	print("Part 1 : ")
	println(part1)
	print("Part 2 : ")
	println(part2)
end