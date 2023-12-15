const std = @import("std");

const Lens = struct { name: [8]u8, value: u8 }; 

pub fn main() !void {
	var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

	const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

	const file = try std.fs.cwd().openFile(if (args.len > 1) 
		args[1] else "input.txt", .{});
	defer file.close();

	var reader = std.io.bufferedReader(file.reader());
	const input_stream = reader.reader();
	var buf: [16]u8 = undefined;

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

	var total: u64 = 0;
	var boxes = [_][9]Lens{ [_]Lens{.{ .name=.{0,0,0,0,0,0,0,0}, .value=0 }} ** 9 } ** 256;
	var boxCursors: [256]u8 = std.mem.zeroes([256]u8);

	while(try input_stream.readUntilDelimiterOrEof(&buf, ',')) |value| {
		const temp = hash(value);
		const box = getBoxNum(value);
		const set = isSetOperation(value);
		const remove = isRemoveOperation(value);
		const label = getLensLabel(value);
		const idx = lensWithLabelIndex(boxes[box], label);

		if (set) {
			if (idx == 10) {
				const newLens = Lens{
					.name=label,
					.value=try focalLength(value),
				};
				boxes[box][boxCursors[box]] = newLens;
				boxCursors[box] = boxCursors[box] + 1;
			} else {
				boxes[box][idx].value = try focalLength(value);
			}
		}

		if (remove) {
			if (idx != 10) {
				for(idx..8) |i| {
					boxes[box][i] = boxes[box][i+1];
				}
				boxes[box][8].name=.{0,0,0,0,0,0,0,0};
				boxes[box][8].value=0;
				boxCursors[box] = boxCursors[box] - 1;
			}
		}

		total += temp;
	}

	try stdout.print("Part 1 : {d}\n", .{total});
	total = 0;

	for(0.., boxes) |i, box| {
		for(0.., box) |j, lens| {
			total += (i+1) * (j+1) * lens.value;
		}
	}

	try stdout.print("Part 2 : {d}\n", .{total});

    try bw.flush(); // don't forget to flush!
}

pub fn hash(value: []u8) u8 {
	const value_len: usize = value.len;
	var result: u8 = 0;

	for (0..value_len) |i| {
		if (value[i] == 0) {
			break;
		}
		result = (result +% value[i]) *% 17; 
	}

	return result;
}

pub fn lensWithLabelIndex(box: [9]Lens, label: [8]u8) usize {
	for (0..9) |i| {
		if (std.mem.eql(u8, &box[i].name, &label)) {
			return i;
		}
	}

	// clearly out of bounds for the array, 
	// use this as a way to test if an index was found
	return 10;
}

pub fn getCursor(value: []u8) usize {
	var cursor: usize = 0;

	while (value[cursor] != '=' and value[cursor] != '-') {
		cursor += 1;
	}

	return cursor;
}

pub fn getLensLabel(value: []u8) [8]u8 {
	var result: [8]u8 = std.mem.zeroes([8]u8);
	for (0..getCursor(value)) |i| {
		result[i] = value[i];
	}
	return result;
}

pub fn getBoxNum(value: []u8) u8 {
	var toHash = [_]u8{0} ** 10;
	const label = getLensLabel(value);
	for(0..8) |i| {
		toHash[i] = label[i];
	}
	return hash(&toHash);
}

pub fn isRemoveOperation(value: []u8) bool {
	return (value[getCursor(value)] == '-');
}

pub fn isSetOperation(value: []u8) bool {
	return (value[getCursor(value)] == '=');
}

pub fn focalLength(value: []u8) error{Overflow,InvalidCharacter}!u8 {
	const begin = getCursor(value) + 1;
	const end = value.len;
	const str = value[begin..end];

	return try std.fmt.parseInt(u8, str, 10);
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
