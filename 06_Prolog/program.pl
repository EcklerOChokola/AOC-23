:- initialization(main).

main :- 
  current_prolog_flag(argv, [File|_]),  
  open(File, read, Stream),
  read_line_to_string(Stream, TimesLine),
  values_from_string(TimesLine, Times),
  read_line_to_string(Stream, DistancesLine),
  values_from_string(DistancesLine, Distances),
  close(Stream), 
  solve_part_one(Times, Distances, Product),
  write("Part 1 : "),
  writeln(Product),
  solve_part_two(Times, Distances, Sum),
  write("Part 2 : "),
  writeln(Sum),
  halt.

solve_part_one([], _, Product) :-
  Product is 1.
solve_part_one(_, [], Product) :-
  Product is 1.
solve_part_one([T|Lt], [D|Ld], P):-
  number_of_wins(T, D, X),
  solve_part_one(Lt, Ld, SubP),
  P is SubP * X.

number_of_wins(T, D, Sum) :-
  first_win(0, T, D, X),
  last_win(T, T, D, Y),
  Sum is Y - X + 1.

first_win(T, T, _, 0).
first_win(B, T, D, X) :-
  Travelled is (T - B) * B,
  (
    Travelled > D -> 
    X is B; 
    NewB is B + 1,
    first_win(NewB, T, D, X)
  ).

last_win(0, _, _, 0).
last_win(B, T, D, X) :-
  Travelled is (T - B) * B,
  (
    Travelled > D -> 
    X is B; 
    NewB is B - 1,
    last_win(NewB, T, D, X)
  ).

solve_part_two(Times, Distances, Sum) :-
  string_join(Times, TimeString),
  string_join(Distances, DistanceString),
  number_string(Time, TimeString),
  number_string(Distance, DistanceString),
  number_of_wins(Time, Distance, Sum).

string_join([], "").
string_join([X|L], String) :-
  string_join(L, S),
  number_string(X, Y),
  string_concat(Y, S, String).  

values_from_string(Line, T) :-
  split_string(Line, " ", " ", [_|List]),
  numbers_strings(List, T).

numbers_strings([], []).
numbers_strings([X|L], [Y|M]):-
  number_string(Y, X),
  numbers_strings(L, M).
  