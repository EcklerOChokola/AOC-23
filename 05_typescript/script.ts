import { createReadStream } from "fs";
import readline from "readline";
import path from "path";
import { argv } from "process";

let filename = "input.txt";
if (argv.length > 2) {
  filename = argv[2];
}

type Range = {
  begin: number
  end: number
  shift: number
}

type Map = {
  ranges: Range[]
}

let initial_seeds: number[];
let seeds: number[];
let seedsRangesFirst: number;
let maps: Map[] = [];
let index: number = -1;
let min = Number.MAX_VALUE;

const seedsToSeedsRanges = (values: number[]) => {
  for (let i = 0; i < values.length; i++) {
    if (i%2 == 0) {
      seedsRangesFirst = values[i]
    } else {
      for (let j = 0; j < values[i]; j++) {
        let value = seedsRangesFirst + j;
        for (let k = 0; k < maps.length; k++) {
          value = applyMap(maps[k], value);
        }
        min = (value - min < 0) ? value : min
      }
    }
  }
}

const readSeeds = (line: string) => {
  let split = line.split(' ')
  split.shift();
  initial_seeds = split.map((value: string) => parseInt(value));
  seeds = initial_seeds;
}

const readRange = (line: string): Range => {
  const [dest, src, len] = line.split(' ').map((value: string) => parseInt(value));
  const beg = src;
  const end = src + len - 1;
  const sft = dest - src;

  return {
    begin: beg,
    end,
    shift: sft
  };
}

const isInRange = (range: Range, value: number) => {
  return (range.begin <= value) && (range.end >= value);
}

const shiftRange = (range: Range, value: number) => {
  return isInRange(range, value) ? value + range.shift : value;
}

const applyMap = (map: Map, value: number) => {
  const range = map.ranges.find((range: Range) => isInRange(range, value))
  if (range) {
    value = shiftRange(range, value)
  }
  return value
}

let reader = readline.createInterface(createReadStream(path.join(process.cwd(), filename)))
reader.on("line", (line: string) => {
  if (!seeds) {
    readSeeds(line);
    return;
  }
  if (line == "") {
    index++;
    maps.push({ ranges: [] });
    return;
  }
  if (line.endsWith(":")) {
    return
  }
  const range: Range = readRange(line);
  maps[index].ranges.push(range)
})

reader.on("close", () => {
  
  for(let i = 0; i <= index; i++) {
    seeds = seeds.map((value: number) => applyMap(maps[i], value))
  }
  console.log(`Part 1 : ${seeds.sort((a, b) => a - b)[0]}`)

  seedsToSeedsRanges(initial_seeds)
  console.log(`Part 2 : ${min}`)
})

export default {}