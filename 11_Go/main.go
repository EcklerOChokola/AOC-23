package main 

import (
	"fmt"
	"os"
	"strings"
)

type Position struct {
	X	int
	Y 	int
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func min(a int, b int) int {
	if a > b {
		return b
	}
	return a
}

func max(a int, b int) int {
	if a < b {
		return b
	}
	return a
}

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}

func modified_manhattan(initial Position, final Position, double_columns []int, double_lines []int, multiplier int) int {
	count_cols := 0
	count_lines := 0
	for _, k := range double_columns[min(initial.Y, final.Y):max(initial.Y, final.Y)] {
		count_cols += k * (multiplier - 1)
	}
	for _, k := range double_lines[min(initial.X, final.X):max(initial.X, final.X)] {
		count_lines += k * (multiplier - 1)
	}
	return abs(final.X - initial.X) + abs(final.Y - initial.Y) + count_cols + count_lines
}

func main() {

	argsNoProg := os.Args[1:]
	var input string
	input = "input.txt"
	if len(argsNoProg) != 0 {
		input = argsNoProg[0]
	}

	data, err := os.ReadFile(input)
	check(err)
	file := strings.Split(string(data), "\r\n")

	var double_lines []int 
	var double_columns []int
	var positions []Position

	for range file[0] {
		double_columns = append(double_columns, 1)
	}
	for i, s := range file {
		if ! strings.Contains(s, "#") {
			double_lines = append(double_lines, 1)
		} else {
			double_lines = append(double_lines, 0)
			for j, c := range s {
				if c == '#' {
					double_columns[j] = 0
					positions = append(positions, Position{i, j})
				}
			}
		}
	}

	distance_one := 0
	distance_two := 0
	for i := range positions {
		for j := i + 1; j < len(positions); j++ {
			distance_one += modified_manhattan(positions[i], positions[j], double_columns, double_lines, 2)
			distance_two += modified_manhattan(positions[i], positions[j], double_columns, double_lines, 1000000)
		}
	}

	fmt.Println("Part 1 : ", distance_one)
	fmt.Println("Part 2 : ", distance_two)

}