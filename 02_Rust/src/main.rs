use std::fs;
use std::str;
use std::str::FromStr;

struct TurnCounts {
  red:   i32,
  blue:  i32,
  green: i32,
}

fn main() {
  let input_path = "input.txt";
  let contents = fs::read_to_string(input_path).expect("{input_path} could not be open");

  let split = contents.lines();
  let mut count: i32 = 0;
  let mut sum_of_powers: i32 = 0;

  for line in split {
    if test_line(&line) {
      count += game_id(&line);
    }
    sum_of_powers += power_of_line(&line);
  }

  println!("Part 1 : {count}");
  println!("Part 2 : {sum_of_powers}");
}

fn test_line(line: &str) -> bool {
  let mut split = (*line).split(": ");
  split.next();
  let list_of_turns = split.next().expect("Should have a list of turns").split("; ");

  for turn in list_of_turns {
    if !test_turn(turn) {
      return false;
    }
  }

  return true;
}

fn game_id(line: &str) -> i32 {
  let game_title = (*line).split(": ").next().expect("Should hav a game title");
  let mut split = game_title.split(" ");
  split.next();
  let id_as_string = split.next().expect("Should have an ID");
  
  return i32::from_str(id_as_string).unwrap();
}

fn test_turn(turn: &str) -> bool {
  let split = (*turn).split(", ");

  for ball_count in split {
    let count = i32::from_str(
      ball_count.split(" ").next().expect("Should have a count")
    ).unwrap();

    if (ball_count.contains("red")   && count > 12 ) 
    || (ball_count.contains("blue")  && count > 14 )
    || (ball_count.contains("green") && count > 13 ) {
      return false;
    }
  }

  return true;
}

fn power_of_line(line: &str) -> i32 {
  let mut split = (*line).split(": ");
  split.next();
  let turns = split.next().expect("Should have turns").split("; ");
  let mut min = TurnCounts { red: 0, blue: 0, green: 0 };

  for turn in turns {
    let new: TurnCounts = turn_values(turn);

    min.red   = if min.red   > new.red   { min.red   } else { new.red   };
    min.blue  = if min.blue  > new.blue  { min.blue  } else { new.blue  };
    min.green = if min.green > new.green { min.green } else { new.green };
  }

  return min.red * min.blue * min.green;
}

fn turn_values(turn: &str) -> TurnCounts {
  let split = (*turn).split(", ");
  let mut values = TurnCounts { red: 0, blue: 0, green: 0 };

  for ball_count in split {
    let count = i32::from_str(
      ball_count.split(" ").next().expect("Should have a count")
    ).unwrap();
    
    if ball_count.contains("red"  ) { values.red   = count };
    if ball_count.contains("blue" ) { values.blue  = count };
    if ball_count.contains("green") { values.green = count };
  }

  return values;
}
