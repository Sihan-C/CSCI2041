let wordlist s =
  let splitlist = Str.full_split (Str.regexp "\\b\\|(\\|)") s in
  let rec filter_splist lst = match lst with
    | [] -> []
    | (Str.Delim "(")::t -> "(" :: (filter_splist t)
    | (Str.Delim ")")::t -> ")" :: (filter_splist t)
    | (Str.Delim _) :: t -> filter_splist t
    | (Str.Text s) :: t -> let s' = String.trim s in
			   let t' = (filter_splist t) in
			   if not (s' = "") then s' :: t' else t' 
  in filter_splist splitlist
		   

type token = Open | Close | And | Or | Not | T of bool | F of bool | Var of string   
let tokens_p f (slst:string list) =  
  let rec helper (accum:token list) l = match l with
    | [] -> accum 
    | h::t ->  match h with       (* If we find the token, then add them to the token list *)
        | "(" -> helper (Open::accum) t
        | ")" -> helper (Close::accum) t
        | "and" -> helper (And::accum) t
        | "or" -> helper (Or::accum) t
        | "not" -> helper (Not::accum) t
        | "T" -> helper ((T true)::accum) t
        | "F" -> helper ((F false)::accum) t
        | ss  -> if f h then helper ((Var ss)::accum) t    (* if it is a legal variable name, add it to the token list*)
                 else helper accum t                       (* If it is not a legal variable name, continue*)
  in List.rev( helper [] slst)  

(* explode function is used to turn a string into char list *)
let explode s1 =
  let rec help x l =
       if x < 0 then l
       else help (x - 1) (s1.[x] :: l)
  in help (String.length s1 - 1) [] 

let lowervars (s:string) = match (explode s) with (* The first match check the first character.*) 
     | [] -> false 
     | h::t -> if ('a' > h) || (h > 'z') || ('0' <= h && h <= '9') then false   
               else let rec helper l = match l with 
	            | [] -> true
	            | h1::t1 -> if ('a' > h && h > 'z') then false
                                else helper t1
		    in helper t    
                              
            
let tokens slst = tokens_p lowervars slst 


type boolExpr = ConstExpr of bool | VarExpr of string | AndExpr of boolExpr * boolExpr | OrExpr of boolExpr * boolExpr | NotExpr of boolExpr 

(* A token list representing a boolean expression is either
   + a CONST token :: <more tokens> 
   + an OPEN PAREN token :: a NOT token :: <a token stream representing a boolean expression> @ (a CLOSE PAREN token :: <more tokens>)
   + an OPEN PAREN token :: an AND token :: <a token list representing a boolean expression> @
                                           <a token list representing a boolen expression> @ a CLOSE PAREN token :: <more tokens>
   + an OPEN PAREN token :: an OR token :: <a token list representing a boolean expression> @
                                           <a token list representing a boolen expression> @ a CLOSE PAREN token :: <more tokens>
   any other list is syntactically incorrect. *)


let parse_bool_exp lst =
  let rec helper l = match l with 
  (*The helper function will return a turple, where the first element is an expression, and the second element is the remaining token list.*)
     | (T true)::t -> (ConstExpr true, t)
     | (F false)::t -> (ConstExpr false, t)
     | Open::And::t -> let (qian,hou) = helper t in   (* qian is the first element of the AndExpr, hou is the token list right after it. *)
		        let (qian1,hou1) = helper hou in   (* qian1 is the second element of AndExpr. *)
                        begin
			      match hou1 with  (* If the second argument come with a close parenthesis, then legal, otherwise, not. *)
			      | Close::tt -> (AndExpr (qian, qian1),tt)
                              | _ -> invalid_arg "Parse fail"  
			end	
     | Open::Or::t -> let (qian,hou) = helper t in
		  	let (qian1,hou1) = helper hou in
		         begin 
			      match hou1 with
			      | Close::tt -> (OrExpr (qian, qian1),tt)
                              | _ -> invalid_arg "Parse fail"   
			 end	
     | Open::Not::t -> let (qian,hou) =helper t in
		       begin
                              match hou with
                              | Close::tt -> (NotExpr qian , tt)
			      | _ -> invalid_arg "Parse fail" 
		       end 
     | (Var s)::t -> (VarExpr s,t)
     | _ -> invalid_arg "Parse fail" 	      		      	
  in match (helper lst) with 
     | (x,[])-> x      (* we only need the boolExp, so only the first element of the return value of the helper function. *)
     | _ -> invalid_arg "Parse fail"

  
(*
  Should evaluate an expression, given a function mapping variable names to boolean values.
*)
let rec eval_bool_exp exp1 f = match exp1 with 
  | VarExpr v -> f v
  | AndExpr (x,y) -> (eval_bool_exp x f) && (eval_bool_exp y f)
  | OrExpr (x,y) -> (eval_bool_exp x f) || (eval_bool_exp y f) 
  | NotExpr x -> not (eval_bool_exp x f) 
  | ConstExpr x -> x 


			  			    
let () = if Array.length Sys.argv < 2 then () else
  let (_::sExpr::tlist)  = Array.to_list Sys.argv in
  let bExpr = sExpr |> wordlist |> tokens |> parse_bool_exp in
  let result = eval_bool_exp bExpr (fun v -> List.mem v tlist) in
  let () = print_string ((if result then "True" else "False")^"\n") in
  flush stdout



(* TA COMMENT(zhan4136) Lexing Feedback: 12/12 *)

(* TA Comment(meye2058) Parsing/Evaluation Feedback: 18/18 *)
