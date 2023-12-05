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
let seedsRanges: Range[] = [];
let maps: Map[] = [];
let index: number = -1;

const seedsToSeedsRanges = (values: number[]) => {
  for (let i = 0; i < values.length; i++) {
    if (i%2 == 0) {
      seedsRanges.push({
        begin: values[i],
        end: 0,
        shift: 0
      })
    } else {
      let prev = seedsRanges[seedsRanges.length - 1];
      prev.end = prev.begin + values[i] - 1;
      seedsRanges[seedsRanges.length - 1] = prev;
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

const isInRanges = (ranges: Range[], value: number) => {
  return ranges.map((range) => isInRange(range, value)).reduce((prev, curr) => curr || prev, false)
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

const revertRange = (range: Range): Range => {
  return {
    begin: range.begin + range.shift,
    end: range.end + range.shift,
    shift: -range.shift
  }
}

const revertMap = (map: Map): Map => {
  return {
    ranges: map.ranges.map(revertRange)
  }
}

const revertMaps = (maps: Map[]): Map[] => {
  let resultMap = new Array(maps.length);
  for (let i = 0; i < maps.length; i++) {
    resultMap[maps.length - i - 1] = revertMap(maps[i]);
  }
  return resultMap;
}

const applyMaps = (maps: Map[], value: number): number => {
  for(let i = 0; i < maps.length; i++) {
    value = applyMap(maps[i], value);
  }
  return value;
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
  for(let i = 0; i < maps.length; i++) {
    seeds = seeds.map((value: number) => applyMap(maps[i], value));
  }
  console.log(`Part 1 : ${seeds.sort((a, b) => a - b)[0]}`);

  seedsToSeedsRanges(initial_seeds);
  maps = revertMaps(maps);

  let iterator = 0;
  while(!isInRanges(seedsRanges, applyMaps(maps, iterator))) {
    iterator++;
  }
  console.log(`Part 2 : ${iterator}`)
})

export default {}