# AOC-23
Solutions for the Advent Of Code 2023

## Inputs
All inputs that were given to me are still in the corresponding folders as `input.txt`.

## Organization
I will try to do each day in a different language, most of them I will be trying for the first time.

There will be one folder for each day, with the format:

`XX_Y`

, with `XX` the day with a leading zero if needed, and `Y` the language used.

## Tooling 

Depending on the language, some days might not run if you do not have the tools installed on your machine. 

On the other hand, I haven't even bothered to try to make some languages run on my computer, and I have used online tools for them.

Tooling informations can be found in the last column of the table in the [languages](#languages) section. Some tweaks may be needed for some online tools, which will be written on top of the programs.

## Tests
When achievable on my machine, I will try to put a few tests for the day. These will represent how I tried to find edge-cases for my algorithm.

Each folder that I have implemented tests for will have :

- a `test.sh` script, that will execute all tests for the day;
- a `test_data\` folder, holding one folder for each test. Every subdirectory holds an input and an output txt file.

A general `test.sh` script at the root of the repository will scan all directories and execute the test script in it, or will skip it if it can't be found.

## <a name="languages"></a> Used languages 

| Day 	| Title								| Language 			| Tests 				| Tooling 	|
| :-: 	| -----                           	| :--------:		| :---: 				| ---: 		|
| 01  	| Trebuchet!?                     	| **COBOL** 		| :x: 					| [JDoodle](https://www.jdoodle.com/execute-cobol-online/) (online) |
| 02  	| Cube Conundrum                  	| **Rust** 			| :heavy_check_mark: 	| [Cargo](https://doc.rust-lang.org/cargo/) (on machine) |
| 03  	| Gear Ratios                     	| **python** 		| :heavy_check_mark: 	| [python3](https://www.python.org/download/releases/3.0/) (on machine) |
| 04  	| Scratchcards                		| **RockStar** 		| :x: 					| [RockStar](https://codewithrockstar.com/online) (online) |
| 05  	| If You Give A Seed A Fertilizer 	| **Typescript** 	| :heavy_check_mark: 	| [bun](https://bun.sh/) (on machine) |

## Warnings

Depending on the input, some days may take a long time to run. I have done everything I could to limit the memory usage for these days to 2 gigs of RAM.

I **strongly** advise not to run these days with the input file if you do not need to.

These days are : 

**NONE** *for now ...*
