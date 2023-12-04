# AOC-23
Solutions for the Advent Of Code 2023

## Inputs
All inputs that were given to me are still in the corresponding folders as `input.txt`.

## Organization
I will try to do each day in a different language, most of them I will be trying for the first time.

There will be one folder for each day, with the format:

`XX_Y`

, with `XX` the day with a leading zero if needed, and `Y` the language used.

## Tests
When achievable on my machine, I will try to put a few tests for the day. These will represent how I tried to find edge-cases for my algorithm.

Each folder that I have implemented tests for will have :

- a `test.sh` script, that will execute all tests for the day;
- a `test_data\` folder, holding one folder for each test. Every subdirectory holds an input and an output txt file.

A general `test.sh` script at the root of the repository will scan all directories and execute the test script in it, or will skip it if it can't be found.

## Used languages 

| Day | Title | Language |
| --- | ----- | -------- |
| 01  | Trebuchet!? | **COBOL** |
| 02  | Cube Conundrum | **Rust** |
| 03  | Gear Ratios | **python** |
| 04  | Scratchcards | **RockStar** |
