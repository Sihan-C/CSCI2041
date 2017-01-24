open Bloom

(* Instantiate two BloomFilter modules with SparseSet/BitSet and IntHash *)	
module BloomSparseInt = BloomFilter (SparseSet) (IntHash)
module BloomBitInt = BloomFilter (BitSet) (IntHash)

(* A helper function used to create a list of random numbers *)
let rec helper i acc = match i with 
	| 0 -> acc
	| x -> helper (x-1) (Random.int (1 lsl 30 - 1)::acc) 
let insert_list = helper 200 []

(* Create a BloomSparseInt.t, set1 and measure the running time time1 *) 
let rec create_set1 lst set = match lst with 
	| [] -> set
	| h::t -> create_set1 t (BloomSparseInt.add h set) 

let time1, set1 = 
	let start = Sys.time () in
	let set1 = create_set1 insert_list (BloomSparseInt.empty) in
	let finish = Sys.time () in
	finish -. start, set1 

(* Create a BloomBitInt.t, set2 and measure the running time time2 *) 
let rec create_set2 lst set = match lst with 
	| [] -> set
	| h::t -> create_set2 t (BloomBitInt.add h set) 

let time2 , set2 = 
	let start = Sys.time () in
	let set2 = create_set2 insert_list (BloomBitInt.empty) in
	let finish = Sys.time () in
	finish -. start , set2

(* Create a list test_list of 1 million random integers between 0 and 2^30-1. *)
let test_list = helper 1000000 []

(* Time how long it takes to test for each integers using BloomSparseInt.mem *)
let rec count_fpos1 lst set acc = match lst with 
	| [] -> 0
	| h::t -> if (BloomSparseInt.mem h set) then count_fpos1 t set acc + 1 else count_fpos1 t set acc

let time_testint1 , numpos1 = 
	let start = Sys.time () in
	let numpos1 = count_fpos1 test_list set1 0 in
	let finish = Sys.time () in
	finish -. start , numpos1	 

(* Time how long it takes to test for each integers using BloomBitInt.mem *)
let rec count_fpos2 lst set acc = match lst with 
	| [] -> 0
	| h::t -> if (BloomBitInt.mem h set) then count_fpos2 t set acc + 1 else count_fpos2 t set acc

let time_testbit1 , numpos2 = 
	let start = Sys.time () in
	let numpos2 = count_fpos2 test_list set2 0 in
	let finish = Sys.time () in
	finish -. start , numpos2	 ;;

(* Print out result of SparseInt and BitInt *)
Printf.printf "SparseInt     :build time =  %f s test time = %f false positives = %d\n" time1 time_testint1 numpos1;;
Printf.printf "BitInt        :build time =  %f s test time = %f false positives = %d\n" time2 time_testbit1 numpos2;;


(* Read 2048 most-visited webiste from the file top-2k.txt into a list of strings *)
let insert_list = 
    let in_file = open_in "top-2k.txt" in
    let rec loop acc =
        let next_line = try Some (input_line in_file) with End_of_file -> None in
        match next_line with
            | (Some l) -> loop (l::acc) 
            | None -> acc
        in
    let lines = try List.rev (loop []) with _ -> [] in
    let () = close_in in_file in
    lines

(* Read 2048 most-visited webiste from the file top-1m.txt into a list of strings *)
let test_list = 
    let in_file = open_in "top-1m.txt" in
    let rec loop acc =
        let next_line = try Some (input_line in_file) with End_of_file -> None in
        match next_line with
            | (Some l) -> loop (l::acc) 
            | None -> acc
        in
    let lines = try List.rev (loop []) with _ -> [] in
    let () = close_in in_file in
    lines


(* Instantiate two BloomFilter modules with SparseSet/BitSet and StringHash *)
module BloomSparseString = BloomFilter (SparseSet) (StringHash)
module BloomBitString = BloomFilter (BitSet) (StringHash)

(* Create a BloomSparseString.t, set3 and measure the running time time3 *) 
let rec create_set3 lst set = match lst with 
	| [] -> set
	| h::t -> create_set3 t (BloomSparseString.add h set) 

let time3 , set3 = 
	let start = Sys.time () in
	let set3 = create_set3 insert_list (BloomSparseString.empty) in
	let finish = Sys.time () in
	finish -. start , set3


(* Create a BloomBitString.t, set4 and measure the running time time4 *) 	 
let rec create_set4 lst set = match lst with 
	| [] -> set
	| h::t -> create_set4 t (BloomBitString.add h set) 

let time4 , set4 = 
	let start = Sys.time () in
	let set4 = create_set4 insert_list (BloomBitString.empty) in
	let finish = Sys.time () in
	finish -. start , set4


(* Time how long it takes to test for each integers using BloomSparsetString.mem *)
let rec count_fpos3 lst set acc = match lst with 
	| [] -> 0
	| h::t -> if (BloomSparseString.mem h set) then count_fpos3 t set acc + 1 else count_fpos3 t set acc

let time_testint2 , numpos3 = 
	let start = Sys.time () in
	let numpos3 = count_fpos3 test_list set3 0 in
	let finish = Sys.time () in
	finish -. start , numpos3	 
 

(* Time how long it takes to test for each integers using BloomBitString.mem *)
let rec count_fpos4 lst set acc = match lst with 
	| [] -> 0
	| h::t -> if (BloomBitString.mem h set) then count_fpos4 t set acc + 1 else count_fpos4 t set acc

let time_testbit2 , numpos4 = 
	let start = Sys.time () in
	let numpos4 = count_fpos4 test_list set4 0 in
	let finish = Sys.time () in
	finish -. start , numpos4 ;;

(* Print out result of SparseInt and BitInt *)
Printf.printf "SparseString     :build time =  %f s test time = %f false positives = %d\n" time3 time_testint2 numpos3;;
Printf.printf "BitString        :build time =  %f s test time = %f false positives = %d\n" time4 time_testbit2 numpos4;;
(*TA Comment halto004:
  -Correct tests present: 5/5
  -Using correct modules: 4/4

*)
(* TA COMMENT (leid0065): 6/6 *)
