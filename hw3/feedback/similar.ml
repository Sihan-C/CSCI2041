(* The only explicit recursion in this file should be in this pre-defined function *)
let file_lines fname = 
  let in_file = open_in fname in
  let rec loop acc =
    let next_line = try Some (input_line in_file) with End_of_file -> None in
    match next_line with
    | (Some l) -> loop (l::acc)
    | None -> acc
  in
  let lines = try List.rev (loop []) with _ -> [] in
  let () = close_in in_file in
  lines

let file_as_string fname = String.concat "\n" (file_lines fname)
			 
let split_words = Str.split (Str.regexp "\\b") 

(* Your code goes here: *)
(* Read the list of representative text files *)
let filelst = file_lines Sys.argv.(1)
 
(* Read	the contents of each text file: *)		
let textlst = List.map file_as_string filelst
 
(* Read the contents of the target text file *)
let target_content = file_as_string Sys.argv.(2)
  		   
(* Define the function that converts a string into a list of words *)			
let words s = List.fold_right ( fun x y -> if ( String.contains x ' ' ) then y else x::y ) ( split_words ( String.map (fun x -> if ( 'a' <= x && x <= 'z' ) || ( 'A' <= x && x <= 'Z' ) then x else ' '  ) s ) ) []  
				   
(* Store the list of words from each representative *)
let wordslst = List.map words textlst 
			    
(* Convert the target text file into a list of words *)
let target_words = words target_content
 
(* Use Stemmer.stem to stem all of the words in the input, but only if I can make stemmer work. *)
let stemmed_lst = List.fold_right ( fun x y -> ( List.map ( Stemmer.stem ) x ) :: y ) wordslst []
let target_words_stemmed = List.map ( Stemmer.stem ) target_words

(* Define a function to convert a list into a set *)
let to_set lst = List.rev ( List.fold_left ( fun x y -> if List.mem y x then x else y::x ) [] lst ) 

(* Convert all of the stem lists into stem sets *)				
let stemmed_set = List.map to_set stemmed_lst
let target_words_stemmed_set = to_set target_words_stemmed
 		
(* Define the similarity function between two sets: size of intersection / size of union *)			
let intersection_size lst1 lst2 = List.fold_right (fun x cnt -> if List.mem x lst2 then cnt + 1 else cnt ) lst1 0  
let union_size lst1 lst2 = List.fold_right (fun x cnt -> if List.mem x lst2 then cnt else cnt + 1 ) lst1 ( List.length lst2 )  
let similarity lst1 lst2 = float_of_int ( intersection_size lst1 lst2 ) /. float_of_int ( union_size lst1 lst2 ) 

(* Find the most similar representative file *)
let similarity_lst = List.fold_right ( fun x z -> ( similarity x target_words_stemmed_set )::z ) stemmed_set [] 
let most_similar_file = List.fold_right2 ( fun x y z -> if y > ( snd z ) then ( x, y ) else z ) filelst similarity_lst ("",0.0)

(* print the result *)
let () = print_string ( "The most similar file to " ^ ( Sys.argv.( 2 ) ) ^ " was " ^ fst most_similar_file ^ "\n ")
let () = print_string (string_of_float ( snd most_similar_file ) ^ "\n ")
(* this last line just makes sure the output prints before the program exits *)			    
let () = flush stdout


(* TA COMMENT(zhan4136) Reading the File List: 4/4 *)

(* TA COMMENT(zhan4136) Splitting into Words: 5/5 *)

(* TA COMMENT(zhan4136) Canonicalization: 4/4 *)

(* TA COMMENT(zhan4136) Converting to Sets: 5/5 *)

(* TA COMMENT(zhan4136) Define the Similarity Function: 12/12 *)
