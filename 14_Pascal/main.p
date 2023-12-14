program Day14(output);

uses SysUtils;

type
	IntDoubleArray = array of array of integer;

function GoNorth(Values : IntDoubleArray; Height: integer; Width: integer) : IntDoubleArray;
var 	
	i,j,k 		: integer;
	NewValues	: IntDoubleArray;
begin
	setLength(NewValues, Height, Width);
	for i := 0 to Height - 1 do
	begin
		for j := 0 to Width - 1 do
		begin
			NewValues[i,j] := Values[i,j];
		end;
	end;
	for i := 0 to Height-1 do
	begin
		for j := 0 to Width-1 do
		begin
			if NewValues[i,j] = 2 then
			begin
				k := i-1;
				if (k <> -1) then
				while NewValues[k,j] = 0 do
				begin
					NewValues[k,j] := 2;
					NewValues[k+1,j] := 0;
					k := k-1;
					if (k = -1) then
					break;
				end;
			end;
		end;
	end;
	Exit(NewValues);
end;

function GoWest(Values : IntDoubleArray; Height: integer; Width: integer) : IntDoubleArray;
var 	
	i,j,k 		: integer;
	NewValues	: IntDoubleArray;
begin
	setLength(NewValues, Height, Width);
	for i := 0 to Height - 1 do
	begin
		for j := 0 to Width - 1 do
		begin
			NewValues[i,j] := Values[i,j];
		end;
	end;
	for i := 0 to Width-1 do
	begin
		for j := 0 to Height-1 do
		begin
			if NewValues[j,i] = 2 then
			begin
				k := i-1;
				if (k <> -1) then
				while NewValues[j,k] = 0 do
				begin
					NewValues[j,k] := 2;
					NewValues[j,k+1] := 0;
					k := k-1;
					if (k = -1) then
					break;
				end;
			end;
		end;
	end;
	Exit(NewValues);
end;

function GoSouth(Values : IntDoubleArray; Height: integer; Width: integer) : IntDoubleArray;
var 	
	i,j,k 		: integer;
	NewValues	: IntDoubleArray;
begin
	setLength(NewValues, Height, Width);
	for i := 0 to Height - 1 do
	begin
		for j := 0 to Width - 1 do
		begin
			NewValues[i,j] := Values[i,j];
		end;
	end;
	for i := 1 to Height do
	begin
		for j := 0 to Width-1 do
		begin
			if NewValues[Height-i,j] = 2 then
			begin
				k := i-1;
				if (k <> 0) then
				while NewValues[Height-k,j] = 0 do
				begin
					NewValues[Height-k,j] := 2;
					NewValues[Height-k-1,j] := 0;
					k := k-1;
					if (k = 0) then
					break;
				end;
			end;
		end;
	end;
	Exit(NewValues);
end;

function GoEast(Values : IntDoubleArray; Height: integer; Width: integer) : IntDoubleArray;
var 	
	i,j,k 		: integer;
	NewValues	: IntDoubleArray;
begin
	setLength(NewValues, Height, Width);
	for i := 0 to Height - 1 do
	begin
		for j := 0 to Width - 1 do
		begin
			NewValues[i,j] := Values[i,j];
		end;
	end;
	for i := 1 to Width do
	begin
		for j := 0 to Height-1 do
		begin
			if NewValues[j,Width-i] = 2 then
			begin
				k := i-1;
				if (k <> 0) then
				while NewValues[j,Width-k] = 0 do
				begin
					NewValues[j,Width-k] := 2;
					NewValues[j,Width-k-1] := 0;
					k := k-1;
					if (k = 0) then
					break;
				end;
			end;
		end;
	end;
	Exit(NewValues);
end;

function ComputeScore(Values: IntDoubleArray; Height: integer; Width: integer) : longInt;
var 
	i,j			: integer;
	total		: longInt;
	subtotal	: longInt;
begin
	total := 0;
	for i := 1 to Height do
	begin
		subtotal := 0;
		for j := 1 to Width do
		begin
			if (Values[Height - i,Width - j] = 2) then
			begin
				subtotal := subtotal + i;
			end;
		end;
		total := total + subtotal;
	end;
	Exit(total);
end;

function IntDoubleArrayEqual(that: IntDoubleArray; this: IntDoubleArray; Height: integer; Width: integer):boolean;
var 
	i,j 	: integer;
begin
	for i := 0 to Height-1 do
	begin
		for j := 0 to Width-1 do
		begin
			if (that[i,j] <> this[i,j]) then
				Exit(false);
		end;
	end;	
	Exit(true);
end;

procedure ParseFile(filename:string);
var
	F 				: Text;
	Line			: string;
	Height			: integer;
	Width			: integer;
	Values 			: IntDoubleArray;
	NewValues 		: IntDoubleArray;
	i,j,k			: longInt;
	Arrays			: array of IntDoubleArray;
	score			: longInt;
	equal			: boolean;
	begin_of_cycle	: longInt;
	cycle_length	: longInt;
	billion			: longInt;
	number_of_cycle	: longInt;
begin
	Assign(F,filename);
	Reset(F);
	Height := 0;
	while not eof(F) do
	begin
		ReadLn(F, Line);
		setLength(Values, Height + 1, Length(Line));
		for i := 0 to Length(Line) - 1 do
		begin	
			case Line[i+1] of
				'.' : Values[Height,i] := 0;
				'#' : Values[Height,i] := 1;
				'O' : Values[Height,i] := 2;
			end;
		end;
		Height := Height+1;
	end;
	Width := Length(Line);
	setLength(NewValues, Height, Width);
	setLength(Arrays, 1);
	{ Let round rocks roll North }
	Values := GoNorth(Values, Height, Width);
	{ Part 1 }
	WriteLn(Format('Part 1 : %d', [ComputeScore(Values, Height, Width)]));
	Values := GoWest(Values, Height, Width);
	Values := GoSouth(Values, Height, Width);
	Values := GoEast(Values, Height, Width);
	{ End of first cycle }

	Arrays[0] := Values;

	equal := false;
	billion := 1000000000;
	for i := 1 to billion do
	begin		
		NewValues := GoNorth(Values, Height, Width);
		NewValues := GoWest(NewValues, Height, Width);
		NewValues := GoSouth(NewValues, Height, Width);
		NewValues := GoEast(NewValues, Height, Width);
		for j := 0 to i-1 do
		begin
			if IntDoubleArrayEqual(NewValues, Arrays[j], Height, Width) then
			begin
				equal := true;
				begin_of_cycle := j;
				cycle_length := i - j;
				number_of_cycle := (billion - begin_of_cycle) div cycle_length;
				break;
			end;
		end;
		if (not equal) then
		begin
			setLength(Arrays, i + 1);
			Arrays[i] := NewValues;
			Values := NewValues;
		end
		else
		begin
			break;
		end;
	end;

	WriteLn(Format('Part 2 : %d', [ComputeScore(Arrays[billion - number_of_cycle * cycle_length -1], Height, Width)]));
end;

{ Main program }
var
	filename		: string;
begin
	if (paramCount() > 0) then
	begin
		filename := paramStr(1);
	end
	else
	begin
		filename := 'input.txt';
	end;
	ParseFile(filename);
end.