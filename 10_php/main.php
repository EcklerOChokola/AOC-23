<?php

function where_to_go($from, $char) {
	switch (implode("", array($from, $char))) {
		case 'E-':
		case 'S7':
		case 'NJ':
			return 'W';
		case 'EF':
		case 'W7':
		case 'N|':
			return "S";
		case 'EL':
		case 'S|':
		case 'WJ':
			return "N";
		case 'SF':
		case 'W-':
		case 'NL':
			return "E";
		default:
			break;
	}
}

function next_position($pos, $direction) {
	switch ($direction) {
		case "E":
			return array ($pos[0], $pos[1] + 1);
		case "S":
			return array ($pos[0] + 1, $pos[1]);
		case "W":
			return array ($pos[0], $pos[1] - 1);
		case "N":
			return array ($pos[0] - 1, $pos[1]);
		default:
			break;
	}
}

function inverse_direction($dir) {
	switch ($dir) {
		case "E":
			return "W";
		case "W":
			return "E";
		case "N":
			return "S";
		case "S":
			return "N";
		default:
			return 0;
	}
}

function move($pos, $from, $values) {
	if (($pos[0] == -1) || ($pos[1] == -1) || ($values[$pos[0]][$pos[1]] == "")) {
		return 0;
	}
	$direction = where_to_go($from, $values[$pos[0]][$pos[1]]);
	$next = next_position($pos, $direction);
	if ($next == null) {
		return 0;
	}
	return array($next[0], $next[1], inverse_direction($direction));
}

function get_pos($move) {
	return array($move[0], $move[1]);
}

function get_from($move) {
	return $move[2];
}

function try_direction($pos, $from, $values, $departure) {
	$counter = 0;
	while ($pos != $departure) {
		$move = move($pos, $from, $values);
		if ($move == 0) {
			return array(0, 0);
		}
		$pos = get_pos($move);
		$from = get_from($move);
		$counter++;
	}
	return array($counter, $from);
}

function selecting_array($pos, $from, $values, $departure) {
	$result = array_fill(0, count($values), array_fill(0, count($values[0]), false));
	$result[$pos[0]][$pos[1]] = true;
	while ($pos != $departure) {
		$move = move($pos, $from, $values);
		$pos = get_pos($move);
		$from = get_from($move);
		$result[$pos[0]][$pos[1]] = true;
	}
	return $result;
}

function key_from_dirs($from, $to) {
	return match(implode("", array($from, $to))) {
		'SS', 'NN' => '|',
		'EE', 'WW' => '-',
		'NW', 'ES' => 'L',
		'NE', 'WS' => 'J',
		'SW', 'EN' => 'F',
		'SE', 'WN' => '7'
	};
}

function filter_by_array($arr, $select, $default, $from, $to) {
	foreach ($arr as $key => $value) {
		if (!$select[$key]) {
			$arr[$key] = $default;
		}
		if ($value == "S") {
			$arr[$key] = key_from_dirs($from, $to);
		}
	}
	return $arr;
}

function count_in_column($col) {
	$counter = 0;
	$outside = true;
	$in_pipe_from_north = false;
	$in_pipe_from_south = false;
	for ($i = 0; $i < count($col); $i++) {
		switch ($col[$i]) {
			case '7':
				if($in_pipe_from_north) {
					$outside = !$outside;
				}
				$in_pipe_from_north = false;
				$in_pipe_from_south = false;
				break;
			case 'J':
				if($in_pipe_from_south) {
					$outside = !$outside;
				}
				$in_pipe_from_north = false;
				$in_pipe_from_south = false;
				break;
			case 'F':
				$in_pipe_from_south = true;
				break;
			case 'L':
				$in_pipe_from_north = true;
				break;
			case '|':
				$outside = !$outside;
				break;
			case '.':
				if (!$outside) {
					$counter++;
				}
				break;
			default: 
				break;
		}
	}
	return $counter;
}

$in_file = "input.txt";
if ($argc > 1) {
	$in_file = $argv[1];
}

$input = fopen($in_file, "r") or die("File not found\n");

# Read the input 
$lines = explode("\n", fread($input, filesize($in_file)));
$chars = array_map("str_split", $lines);
foreach ($chars as $key => $value) {
	if (array_search("S", $value) !== false) {
		$entry = array ($key, array_search("S", $value));
		$east = array ($key, array_search("S", $value) + 1);
		$west = array ($key, array_search("S", $value) - 1);
		$south = array ($key + 1, array_search("S", $value));
		$north = array ($key - 1, array_search("S", $value));
	}
}

$departures = array($east, $west, $north, $south);
$initial_froms = array("W", "E", "S", "N");
$indices = array(0, 1, 2, 3);

$pipes = array_map(fn($x) => try_direction($departures[$x], $initial_froms[$x], $chars, $entry), $indices);
$pipe_len = max(array_map(fn($x) => $x[0], $pipes));
$part1 = ($pipe_len + 1) / 2;

$index = array_search($pipe_len, array_map(fn($x) => $x[0], $pipes));
$from = $pipes[$index][1];
$to = $initial_froms[$index];
$select = selecting_array($departures[$index], $initial_froms[$index], $chars, $entry);
$part2_arr = array_map(fn($x, $y) => filter_by_array($x, $y, ".", $from, $to), $chars, $select);
$part2 = array_sum(array_map('count_in_column', $part2_arr));

# Close the input
fclose($input);

print("Part 1 : ".$part1."\n");
print("Part 2 : ".$part2."\n");

?>