(* Function foward_search *)
(* This function is also using the strategy in problem 4. An accumulator is used to 
    achieve the tail recursion. *)
let foward_search f y dict =
    let rec tail_search l accum = match l with 
        | [] -> accum
        | q::h -> if ( f q ) = y then tail_search h (q::accum)
                  else tail_search h accum
    in List.rev(tail_search dict []) 


(* Open filename, and return a list of lines as strings.  Catches
input_line exceptions, but will raise exceptions caused by open_in *)
let read_input_lines filename = 
  let in_file = open_in filename in
  let rec loop acc =
    let next_line = try Some (input_line in_file) with End_of_file -> None in
        match next_line with
        | (Some l) -> loop (l::acc)
        | None -> acc
  in
  let lines = try List.rev (loop []) with _ -> [] in
  let () = close_in in_file in
    lines


(* This function basically call foward_string function with Digest.string as argument, a hex string input on the command line 
    as y and dictionary stored in /usr/share/dict/words as dict. *)     
let () = 
   let x = foward_search (Digest.string) (Digest.from_hex (Sys.argv.(1))) (read_input_lines "/usr/share/dict/words")
   in  if x = [] then print_string (" No match found " ^ "\n")
       else 
           (* head function is used to get the first element in a list *)
           let head = function  
             | [] -> ""       (* It can't happen, since we only pass x can't be an empty list in this branch, put a match 
                               [] with "" is just to make the pattern matching exhaustive. *)
             | h::_ -> h     
           in         
               print_string (" Found a match: " ^ (head x) ^ "\n")         
 

