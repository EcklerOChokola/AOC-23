open Types
open Printf

exception InvalidCard

let char_to_card x = match x with
| 'A' -> Ace
| 'K' -> King
| 'Q' -> Queen
| 'J' -> Jack
| 'T' -> Ten
| '9' -> Nine
| '8' -> Eight
| '7' -> Seven
| '6' -> Six
| '5' -> Five
| '4' -> Four
| '3' -> Three
| '2' -> Two
| _ -> raise InvalidCard

let card_to_score_one c = match c with
| Ace -> 14
| King -> 13
| Queen -> 12
| Jack -> 11
| Ten -> 10
| Nine -> 9
| Eight -> 8
| Seven -> 7
| Six -> 6
| Five -> 5
| Four -> 4
| Three -> 3 
| Two -> 2

let card_to_score_two c = match c with 
| Jack -> 1
| _ -> card_to_score_one c

let str_to_hand str = str |> String.to_seq |> List.of_seq |> List.map (char_to_card) 

let sort_hand hand = List.fast_sort ( fun x y -> y - x ) hand

let rec sorted_hand_to_list_of_lengths_intermediate hand acc last = match hand with
| [] -> [acc + 1]
| x :: tail -> if x = last then (
  sorted_hand_to_list_of_lengths_intermediate tail (1 + acc) last
) else (
  (acc + 1) :: sorted_hand_to_list_of_lengths_intermediate tail 0 x
)

let sorted_hand_to_list_of_lengths hand = sorted_hand_to_list_of_lengths_intermediate (sort_hand hand) 0 0

let rec remove_jokers_of_hand hand = match hand with 
| [] -> []
| 1 :: tail -> remove_jokers_of_hand tail
| x :: tail -> x :: (remove_jokers_of_hand tail)

let rec count_jokers_intermediate hand acc = match hand with 
| [] -> acc
| 1 :: tail -> count_jokers_intermediate tail (acc + 1)
| x :: tail -> count_jokers_intermediate tail acc

let count_jokers hand = count_jokers_intermediate hand 0

let rec get_type_of_hand_intermediate hand pre_type = match hand with 
| 5 :: tail -> Five_of_a_kind
| 4 :: tail -> Four_of_a_kind
| 3 :: tail -> get_type_of_hand_intermediate tail Three_of_a_kind
| 2 :: tail -> if pre_type = One_pair then Two_pair else (
  if pre_type = Three_of_a_kind then Full_house else (get_type_of_hand_intermediate tail One_pair)
) 
| 1 :: tail -> get_type_of_hand_intermediate tail pre_type
| 0 :: tail -> get_type_of_hand_intermediate tail pre_type
| [] -> pre_type
| _ -> raise InvalidCard

let get_type_of_hand hand = get_type_of_hand_intermediate (sort_hand (sorted_hand_to_list_of_lengths hand)) High_card

let get_type_of_hand_two hand = 
  let jokers = count_jokers hand in 
  match get_type_of_hand (remove_jokers_of_hand hand) with
    | Five_of_a_kind -> Five_of_a_kind
    | Full_house -> Full_house
    | Four_of_a_kind -> if jokers = 1 then Five_of_a_kind else Four_of_a_kind
    | Three_of_a_kind -> (match jokers with 
      | 0 -> Three_of_a_kind
      | 1 -> Four_of_a_kind
      | 2 -> Five_of_a_kind
      | _ -> raise InvalidCard)
    | Two_pair -> if jokers = 1 then Full_house else Two_pair
    | One_pair -> (match jokers with 
      | 0 -> One_pair
      | 1 -> Three_of_a_kind
      | 2 -> Four_of_a_kind
      | 3 -> Five_of_a_kind
      | _ -> raise InvalidCard) 
    | High_card -> (match jokers with 
      | 0 -> High_card
      | 1 -> One_pair
      | 2 -> Three_of_a_kind
      | 3 -> Four_of_a_kind
      | 4 -> Five_of_a_kind
      | 5 -> Five_of_a_kind
      | _ -> raise InvalidCard) 

let type_to_code hand_type = match hand_type with
| High_card -> 0
| One_pair -> 1
| Two_pair -> 2
| Three_of_a_kind -> 3
| Full_house -> 4
| Four_of_a_kind -> 5
| Five_of_a_kind -> 6

let str_to_code_one str = (str_to_hand str) |> List.map (card_to_score_one) |> sort_hand |> get_type_of_hand |> type_to_code
let str_to_code_two str = (str_to_hand str) |> List.map (card_to_score_two) |> sort_hand |> get_type_of_hand_two |> type_to_code

let rec compare_hands_part_one h1 h2 = match (h1, h2) with 
| ([], []) -> 0
| (a :: tail1, b :: tail2) -> if a <> b then b - a else compare_hands_part_one tail1 tail2
| _ -> raise InvalidCard

let compare_strs_part_one str1 str2 = if (str_to_code_one str1) <> (str_to_code_one str2) then (
  (str_to_code_one str2) - (str_to_code_one str1)
) else (
  let h1 = (str_to_hand str1) |> List.map (card_to_score_one) in
  let h2 = (str_to_hand str2) |> List.map (card_to_score_one) in
  compare_hands_part_one h1 h2
)

let rec compare_hands_part_two h1 h2 = match (h1, h2) with 
| ([], []) -> 0
| (a :: tail1, b :: tail2) -> if a <> b then b - a else compare_hands_part_two tail1 tail2
| _ -> raise InvalidCard

let compare_strs_part_two str1 str2 = if (str_to_code_two str1) <> (str_to_code_two str2) then (
  (str_to_code_two str2) - (str_to_code_two str1)
) else (
  let h1 = (str_to_hand str1) |> List.map (card_to_score_two) in
  let h2 = (str_to_hand str2) |> List.map (card_to_score_two) in
  compare_hands_part_two h1 h2
)
