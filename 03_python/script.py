import re

def part_one(lines, line, num):
  regex = r"(\d+)"
  second_regex = r"([^\d\.]+)"
  regex_matches = re.finditer(regex, line)

  total_line = 0
  for _, match in enumerate(regex_matches): 
    if (
      match.start() > 0 and num > 0 and re.findall(second_regex, lines[num-1][match.start()-1:match.end()+1])
    ) or (
      match.start() > 0 and num < len(lines) - 1 and re.findall(second_regex, lines[num+1][match.start()-1:match.end()+1])
    ) or (
      match.start() > 0 and line[match.start()-1:match.start()] != '.'
    ) or (
      num > 0 and re.findall(second_regex, lines[num-1][match.start():match.end()+1])
    ) or (
      num < len(lines) - 1 and re.findall(second_regex, lines[num+1][match.start():match.end()+1])
    ) or (
      match.end() < len(line) - 1 and line[match.end():match.end()+1] != '.'
    ):
      total_line += int(match.group())
  
  return total_line

def part_two(lines, line, num):
  stars = re.finditer("\*", line)
  if stars:
    line_total = 0
    for _, star_match in enumerate(stars):
      adj_nums = []

      if star_match.start() > 0:
        iter = re.finditer("(\d+)", line[0:star_match.start()])

        matched = 0
        for matched in iter:
          pass

        if matched != 0 and matched.end() == star_match.start():
          adj_nums.append(int(matched.group()))

      if star_match.end() < len(line) - 1:
        matched = re.finditer("(\d+)", line[star_match.end():len(line)])
        for group in matched:
          if group.start() == 0:
            adj_nums.append(int(group.group()))

      if num > 0:
        numbers = re.finditer("(\d+)", lines[num-1])
        for number_match in numbers:
          if number_match.end() == star_match.start():
            adj_nums.append(int(number_match.group()))
          if number_match.start() == star_match.end():
            adj_nums.append(int(number_match.group()))
          if number_match.start() <= star_match.start() and number_match.end() >= star_match.end():
            adj_nums.append(int(number_match.group()))

      if num < len(lines):
        numbers = re.finditer("(\d+)", lines[num+1])
        for number_match in numbers:
          if number_match.end() == star_match.start():
            adj_nums.append(int(number_match.group()))
          if number_match.start() == star_match.end():
            adj_nums.append(int(number_match.group()))
          if number_match.start() <= star_match.start() and number_match.end() >= star_match.end():
            adj_nums.append(int(number_match.group()))

      if len(adj_nums) == 2: 
        line_total += adj_nums[0] * adj_nums[1]
    return line_total
  else:
    return 0

with open("input.txt", "r") as input:
  # Initialize global values

  lines = input.read().splitlines()
  part_one_total = 0
  part_two_total = 0
  for i in range(0, len(lines)):
    part_one_total += part_one(lines, lines[i], i)
    part_two_total += part_two(lines, lines[i], i)
  
  # Print results 
  print("Part 1 :", part_one_total)
  print("Part 2 :", part_two_total)
