import java.io.File

fun main(args: Array<String>) {
	var filename = "input.txt"
    if (args.size > 0) {
		filename = args.get(0)
	}
	val lineIt = readlines(filename).iterator()
	var line = lineIt.next()
	val rules = LinkedHashMap<String, List<String>>()
	while (lineIt.hasNext() && line != "") {
		val splits = line.replace("}", "").split("{")
		rules[splits[0]] = splits[1].split(",")
		line = lineIt.next()
	}

	var total: Long = 0
	while (lineIt.hasNext()) {
		line = lineIt.next()
		val map = LinkedHashMap<Char, Long>()
		val splits = line.filterNot { it == '{' || it == '}' } 
			.split(",")
		for (str in splits) {
			map[str.split("=")[0][0]] = str.split("=")[1].toLong()
		}
		if (sortPart(map, rules)) {
			for (entry in map) {
				total += entry.value
			}
		}
	}
	
	println("Part 1 : ${total}")
	println("Part 2 : ${sortRange(rules)}")
}

fun readlines(filename: String): List<String> 
	= File(filename).readLines()

fun sortPart(part: Map<Char, Long>, rules: Map<String, List<String>>): Boolean {
	var rule: List<String> = rules.get("in")!!
	while (true) {
		for (test in rule) {
			if (test.contains(":")) {
				val res = test.split(":")[1]
				val value = test.split(":")[0].split(">", "<")[1].toLong()
				if ((test.contains(">") && part[test[0]]!! > value) ||
					(test.contains("<") && part[test[0]]!! < value)) {
					if (res == "A") return true
					if (res == "R") return false
					rule = rules.get(res)!!
					break
				} 
			} else {
				if (test == "A") return true
				if (test == "R") return false
				rule = rules.get(test)!!
				break
			}
		}
	}
}

// Test all ranges, putting them in a queue 
fun sortRange(rules: Map<String, List<String>>): Long {
	val queue: ArrayDeque<Pair<String, Map<Char, Pair<Long, Long>>>> = ArrayDeque(listOf(Pair("in", mapOf(
		'x' to Pair(1, 4000),
		'm' to Pair(1, 4000),
		'a' to Pair(1, 4000),
		's' to Pair(1, 4000)
	))))

	var total: Long = 0

	while(!queue.isEmpty()) {
		val next = queue.removeFirst()

		// Get ranges 
		var ranges = next.second
		var xRange = ranges['x']!!
		var mRange = ranges['m']!!
		var aRange = ranges['a']!!
		var sRange = ranges['s']!!

		// Stop if any range is invalid
		if (xRange.first > xRange.second || 
			mRange.first > mRange.second ||
			aRange.first > aRange.second ||
			sRange.first > sRange.second) 
		{
			continue
		}

		// Get rule
		val state = next.first

		// If state is final, 
		if (state == "A") {
			total += 	(xRange.second - xRange.first + 1) *
						(mRange.second - mRange.first + 1) *  
						(aRange.second - aRange.first + 1) *  
						(sRange.second - sRange.first + 1) 
			continue
		} else if (state == "R") {
			continue
		}
		val rule = rules.get(state)!!
		for (test in rule) {
			// In case of no condition
			var res = test
			if (test.contains(":")) {
				res = test.split(":")[1]
				val value = test.split(":")[0].split(">", "<")[1].toLong()
				
				if (test.contains(">")) {
					// Append the case where condition is passed
					queue.add(Pair(res, reduceRanges(test[0], ">", value, ranges.toMap())))
					// Reduce current ranges
					ranges = reduceRanges(test[0], "<=", value, ranges)
				}
				
				if (test.contains("<")) {
					// Append the case where condition is passed
					queue.add(Pair(res, reduceRanges(test[0], "<", value, ranges.toMap())))
					// Reduce current ranges
					ranges = reduceRanges(test[0], ">=", value, ranges)
				}
			} else {
				queue.add(Pair(res, ranges.toMap()))
			}
		}
	}
	return total
}

fun reduceRanges(name: Char, op: String, value: Long, ranges: Map<Char, Pair<Long, Long>>): Map<Char, Pair<Long, Long>> {
	var newRanges = ranges.toMutableMap()
	when(op) {
		">" -> newRanges[name] = Pair(max(ranges[name]!!.first, value + 1), ranges[name]!!.second)
		"<" -> newRanges[name] = Pair(ranges[name]!!.first, min(ranges[name]!!.second, value - 1))
		"<=" -> newRanges[name] = Pair(ranges[name]!!.first, min(ranges[name]!!.second, value))
		">=" -> newRanges[name] = Pair(max(ranges[name]!!.first, value), ranges[name]!!.second)
	}
	return newRanges
}

fun min(a: Long, b: Long): Long = if (a > b) b else a
fun max(a: Long, b: Long): Long = if (a < b) b else a