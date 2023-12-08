library(readr)
library(rlist)
library(comprehenr)
library(pracma)

args <- commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
	args[1] = "input.txt"
}
input = read_lines(args[1])

# Contains the instructions in order
lr <- strsplit(input[1], "")[[1]]

contents <- input[-c(1, 2)]
line_to_assoc <- function(line) {
	substrings <- strsplit(line[1], " ")[[1]]
	key <- substrings[1]
	left <- gsub('[(,)]', '', substrings[3])
	right <- gsub('[(,)]', '', substrings[4])
	return (c(key, left, right))
}

# Contains the associations of paths 
assocs <- lapply(contents, line_to_assoc)

get_src <- function(association) {
	return (association[[1]])
}
go_left <- function(association) {
	return (association[[2]])
}
go_right <- function(association) {
	return (association[[3]])
}
find <- function(associations, entry) {
	return (to_list(for (x in associations) if (get_src(x) == entry) x)[[1]])
}

# Gets next entry
get_next <- function(associations, entry, instr) {
	return (find(associations, ifelse(instr == "L", go_left(entry), go_right(entry))))
} 

part1 <- 0
step <- find(assocs, "AAA")

while (get_src(step) != "ZZZ") {
	step = get_next(assocs, step, lr[[(part1 %% (length(lr))) + 1]])
	part1 = part1 + 1
}
cat("Part 1 : ", formatC(part1, digits=16), "\n")

test_is_end <- function(entry) {
	return (endsWith(get_src(entry), "Z"))
}
allTrue <- function(x) length(unique(x)) == 1 && unique(x) == TRUE

compute_path <- function(associations, entry) {
	count <- 0
	step <- entry
	
	while (!test_is_end(step)) {
		step = get_next(assocs, step, lr[[(count %% (length(lr))) + 1]])
		count = count + 1
	}
	return (count)
}

cat("Part 2 : ", formatC(Reduce((pracma::Lcm), 
	(to_list(for (x in assocs) if (endsWith(get_src(x), 'A')) compute_path(assocs, x)))),
	digits=16
	), "\n")