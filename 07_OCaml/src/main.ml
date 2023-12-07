open Card_parser
open Printf
open Types

let check s =
  let n = String.length s in
  if n > 0 && s.[n-1] = '\r' then
    String.sub s 0 (n-1)
  else
    s

let line_to_pair str = 
  let res = String.split_on_char ' ' str in
    let compute x = match x with
    | [a; b] -> (a, int_of_string (check b))
    | _ -> raise InvalidCard
    in compute res

let compare_pairs_part_one pair1 pair2 = compare_strs_part_one (fst pair2) (fst pair1)
let compare_pairs_part_two pair1 pair2 = compare_strs_part_two (fst pair2) (fst pair1)

let read_file filename = 
  let lines = ref [] in
  let chan = open_in filename in
  try
    while true; do
      lines := input_line chan :: !lines
    done; !lines
  with End_of_file ->
    close_in chan;
    List.rev !lines

let rec reduce_pairs_intermediate pairs rank = match pairs with
| [] -> 0
| pair :: tail -> ((snd pair) * rank) + (reduce_pairs_intermediate tail (rank +1))

let reduce_pairs pairs = reduce_pairs_intermediate pairs 1

let () = 
  let filename = if (Array.length Sys.argv) = 1 then "input.txt" else Sys.argv.(1) in
    let pairs = read_file filename
    |> List.map line_to_pair in 
      List.fast_sort compare_pairs_part_one pairs
      |> reduce_pairs
      |> printf "Part 1 : %d\n";
      List.fast_sort compare_pairs_part_two pairs
      |> reduce_pairs
      |> printf "Part 2 : %d\n"
