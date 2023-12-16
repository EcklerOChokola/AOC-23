import std/[os, strformat, sequtils]
#[
    Procedures used during resolution
]#

#[
proc linef(i: int, line: string) =
    echo fmt"[{i}] : {line} -> {line.len}"

proc displayintseq(intseq: seq[seq[int]]) =
    for b in intseq:
        if b.len != 0: 
            stdout.write '#'
        else:
            stdout.write '.'
    echo ""

proc displayintgrid(intgrid: seq[seq[seq[int]]]) =
    for s in intgrid:
        displayintseq s 
]#

proc countintseq(intseq: seq[seq[int]]): int =
    var total = 0
    for b in intseq:
        if b.len != 0: 
            total += 1
    return total

proc countintgrid(intgrid: seq[seq[seq[int]]]): int =
    var total = 0
    for s in intgrid:
        total += countintseq(s)
    return total    

var 
    filename = "input.txt"
    i: int = 0
    j: int = 0
    lls: seq[string] = @[]

if paramCount() != 0:
    filename = paramStr(1)

for line in lines filename:
    #linef(i, line)
    lls.add(@[line])
    if j < line.len:
        j = line.len
    inc i

var 
    # movements on x and y
    moves: array[2, array[4, int]] = [
        [-1, 0, 1, 0], # movements on x
        [0, 1, 0, -1]    # movements on y
    ]
    slashes: array[2, array[4, int]] = [
        [1, 0, 3, 2],
        [3, 2, 1, 0]
    ]

proc walkbeam(lls: seq[string], i, j, x, y: int, dir: int): int =
    var 
        z: int = x
        w: int = y
        positions: seq[array[3, int]] = newSeqWith(1, [x, y, dir])
        grid: seq[seq[seq[int]]] = newSeqWith(i, newSeqWith(j, newSeq[int]()))
    while true:
        var movement_queue: seq[array[3, int]] = newSeq[array[3, int]]()
        if positions.len == 0:
            return countintgrid(grid)
        else: 
            for position in positions:
                z = position[0] + moves[0][position[2]]
                w = position[1] + moves[1][position[2]]
                if 0 <= z and z < i and 0 <= w and w < j:
                    if not (position[2] in grid[z][w]):
                        grid[z][w].add(@[position[2]])
                        let char = lls[z][w]
                        case char:
                        of '.': 
                            movement_queue.add([z, w, position[2]])
                        of '/':
                            movement_queue.add([z, w, slashes[0][position[2]]])
                        of '\\':
                            movement_queue.add([z, w, slashes[1][position[2]]])
                        of '|':
                            # if vertical -> continue
                            if position[2] == 0 or position[2] == 2:
                                movement_queue.add([z, w, position[2]])
                            # if horizontal -> add up and down
                            else: 
                                movement_queue.add([z, w, 0])
                                movement_queue.add([z, w, 2])
                        of '-': 
                            if position[2] == 1 or position[2] == 3:
                                movement_queue.add([z, w, position[2]])
                            else:
                                movement_queue.add([z, w, 1])
                                movement_queue.add([z, w, 3])
                        else:
                            discard ""
            positions = movement_queue
    return countintgrid(grid)

var score = walkbeam(lls, i, j, 0, -1, 1)
echo fmt"Part 1 : {score}"

# Part 2
var maxscore = 0

# Top
for y in 0..j:
    let score = walkbeam(lls, i, j, -1, y, 2)
    if (score > maxscore):
        maxscore = score

# Leftmost
for x in 0..i:
    let score = walkbeam(lls, i, j, x, -1, 1)
    if (score > maxscore):
        maxscore = score

# Bottom 
for y in 0..j:
    let score = walkbeam(lls, i, j, i+1, y, 0)
    if (score > maxscore):
        maxscore = score

# Rightmost
for x in 0..i:
    let score = walkbeam(lls, i, j, x, j+1, 3)
    if (score > maxscore):
        maxscore = score

echo fmt"Part 2 : {maxscore}"