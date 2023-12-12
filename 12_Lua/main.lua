-- read all the contents of the file
function readall(filename)
	local fh = assert(io.open(filename, "rb"))
	local contents = assert(fh:read(_VERSION <= "Lua 5.2" and "*a" or "a"))
	fh:close()
	return contents
end

-- declare some library functions as local to speed up access
local sub = string.sub
local match = string.gmatch
local insert = table.insert
local format = string.format

-- simple split
function mysplit (inputstr, sep)
	if sep == nil then
			sep = "%s"
	end
	local t={}
	for str in match(inputstr, "([^"..sep.."]+)") do
			insert(t, str)
	end
	return t
end

-- used during memoization to check for the existence of a key
function contains(dictionary, key)
	return dictionary[key] ~= nil
end

function find_a_name_for_this(
	dict,
	string, 
	array, 
	index, 
	block_index, 
	current
)
	-- keys for the memoization
	local key = index .. " " .. block_index .. " " .. current

	-- early leave
	if contains(dict, key) then
		return dict[key]
	end

	-- behavior at end of string
	if index == #string then 
		if (block_index == #array and current == 0) then
			return 1
		else
			if (block_index == #array - 1  and current == array[block_index + 1]) then 
				return 1
			else
				return 0
			end
		end
	end
	local result = 0

	-- use input string as a table instead of string.sub everytime, to speed up
	local char = string[index + 1]

	-- compute for current char ., even if it was marked as ?
	if char == "?" or char == "." then 
		-- move cursor
		if  current == 0 then
			result = result + find_a_name_for_this(
				dict, string, array, index + 1, block_index, 0)
		else 
			-- move cursor and check for next block, as current is valid
			if (block_index < #array) and (array[block_index + 1] == current) then
				result = result + find_a_name_for_this(
					dict, string, array, index + 1, block_index + 1, 0)
			end
		end
	end

	-- compute for current char #, even if it was marked as ?
	if char == "?" or char == "#" then 
		-- move cursor and increment size of current block
		result = result + find_a_name_for_this(
			dict, string, array, index + 1, block_index, current + 1)
	end

	-- add result to memoization unit
	dict[key] = result
	return result
end

function main(filename)
	-- initialize everything
	local contents = mysplit(readall(filename), "\n")
	local total = 0
	local total_two = 0
	for i=1, #contents do 
		local splitted = mysplit(contents[i])
		local temp = splitted[1]
		-- string for part 1 as a table
		local string = {}
		-- string for part 2 as a table
		local string_two = {}
		for j=1, #temp do 
			string[j] = sub(temp, j, j)
			string_two[j] = sub(temp, j, j)
			string_two[j + 1*#temp + 1] = sub(temp, j, j)
			string_two[j + 2*#temp + 2] = sub(temp, j, j)
			string_two[j + 3*#temp + 3] = sub(temp, j, j)
			string_two[j + 4*#temp + 4] = sub(temp, j, j)
		end
		-- add ? between original strings
		string_two[1*#temp + 1] = "?"
		string_two[2*#temp + 2] = "?"
		string_two[3*#temp + 3] = "?"
		string_two[4*#temp + 4] = "?"
		-- lengths of blocks as string array
		local array = mysplit(splitted[2], ",")
		local array_two = {}
		for j=1, #array do
			array[j] = tonumber(array[j])
			array_two[j] = array[j]
			array_two[j + #array] = array[j]
			array_two[j + 2*#array] = array[j]
			array_two[j + 3*#array] = array[j]
			array_two[j + 4*#array] = array[j]
		end
		-- call function with initial cursors for both parts, increment totals
		total = total + find_a_name_for_this({}, string, array, 0, 0, 0)
		total_two = total_two + find_a_name_for_this({}, string_two, array_two, 0, 0, 0)
	end
	print(format("Part 1 : %d", total))
	print(format("Part 2 : %d", total_two))
end

-- if supplied with a file as arg, read from it
if (#arg >= 1) then
	main(arg[1])
else
	main("input.txt")
end