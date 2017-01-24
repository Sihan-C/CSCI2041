open Program

(* small example programs:  
   Because we're keeping type inference simple, we'll require functions to have a single argument,
   and declare the type of that argument after a colon.
   To simplify parsing funciton applications, we'll have explicit "app" expressions, so to apply function f to argument x,
   the program will say (app f x).  A multiple argument function will need to be applied to each argument in turn, so the equivalent to the
   Ocaml expression (f x y) will be (app (app f x) y).
*)
let example1 =
  "(let f (fun g : int -> int  (app g 0))
          (print (app f (fun x : int (+ x 2)))))"

let example2 =
  "(let gcd (fun a : int (fun b : int 
            (let q (/ a b)
            (let r (- a (* q b))
                   (seq (while (not (= r 0))
                               (seq (set a b)
                                    (set b r)
                                    (set q (/ a b))
                                    (set r (- a (* q b)))))
                         b)))))
            (print (app (app gcd 217) 527)))"


(* all of the lexical tokens we might encounter in a program *)
type token = OP | CP | AND | OR | NOT | PLUS | MINUS | TIMES | DIV | LET | ID of string | CONST of int | BCONST of bool | LT | GT | EQ | IF | SET | SEQ | WHILE | PRINT | APP | FUN | COLON | ARROW | INT | BOOL | UNIT | READINT 

(* Split a string into a list of words, delimited by spaces, parens, colons, and -> *)
(* never mind the magic regexp *)
let wordlist s =
  let splitlist = Str.full_split (Str.regexp "\\b\\|(\\|)\\|:\\|\\(->\\)") s in
  let rec filter_splist lst = match lst with
    | [] -> []
    | (Str.Delim "(")::t -> "(" :: (filter_splist t)
    | (Str.Delim ")")::t -> ")" :: (filter_splist t)
    | (Str.Delim "->")::t -> "->" :: (filter_splist t)
    | (Str.Delim ":")::t -> ":"::(filter_splist t)
    | (Str.Delim _) :: t -> filter_splist t
    | (Str.Text s) :: t -> let s' = String.trim s in
                           let t' = (filter_splist t) in
                           if not (s' = "") then s' :: t' else t' 
  in filter_splist splitlist

(* turn a word into a token *)
let tokenize_string = function
  | "(" -> OP
  | ")" -> CP
  | "and" -> AND
  | "or" -> OR
  | "not" -> NOT
  | "+" -> PLUS
  | "*" -> TIMES
  | "-" -> MINUS
  | "/" -> DIV
  | "let" -> LET
  | ">" -> GT
  | "<" -> LT
  | "=" -> EQ
  | "if" -> IF
  | "set" -> SET
  | "seq" -> SEQ
  | "while" -> WHILE
  | "app" -> APP
  | "fun" -> FUN
  | ":" -> COLON
  | "->" -> ARROW
  | "int" -> INT
  | "bool" -> BOOL
  | "unit" -> UNIT
  | "print" -> PRINT
  | "true" -> BCONST true
  | "false" -> BCONST false
  | "readint" -> READINT 
  | s -> if Str.string_match (Str.regexp "[0-9]+") s 0 then (CONST (int_of_string s))
	 else if Str.string_match (Str.regexp "[a-z]+") s 0 then (ID s) else failwith ("invalid token:"^s)

(* and a list of words into a list of tokens *)										      
let tokens wl = List.map tokenize_string wl

(* Parse a type expression in a function definition. 
   Return the type and the list of unused tokens for further parsing.
   A type expression is either: INT, BOOL, UNIT or  (typeExpr)  or typeExpr -> typeExpr  *)
let rec parse_type_expr tlist = 
  let (ty1, tl) = 
    match tlist with
    | INT::t -> (Int,t)
    | BOOL::t -> (Bool,t)
    | UNIT::t -> (Unit,t)
    | OP::t -> (* Read up until we find a close paren: covers types like "(int->bool) -> int" *)
       let (ty,t) = parse_type_expr t in
       ( match t with
	 | CP::t' -> (ty,t')
	 | _ -> failwith "imbalanced parentheses in type expression" )
    | _ -> failwith "unexpected token in type expression."
  in match tl with (* peek at tail: is there an arrow (so more type expr to read)? *)
     | ARROW::t1 -> 
	let (ty2, t2) = parse_type_expr t1 in (FunType(ty1,ty2),t2)
     | _ -> (ty1,tl) (* No, we're done here. *)
	      
let parse_program tlist =
  (* parse an expression from a list of tokens, returning the expression and the list of unused tokens *)
  let rec parser tlist = match tlist with
    | [] -> failwith "Ran out of tokens without closing parenthesis"
    | (BCONST b)::t -> (Boolean b,t)
    | (CONST i)::t -> (Const i, t)
    | (ID s)::t -> (Name s, t)
    | OP::PLUS::t -> let (e1,e2,t') = parse_two t in (Add (e1,e2), t')
    | OP::MINUS::t -> let (e1,e2,t') = parse_two t in (Sub (e1,e2), t')						     
    | OP::TIMES::t -> let (e1,e2,t') = parse_two t in (Mul (e1,e2), t')						       
    | OP::DIV::t -> let (e1,e2,t') = parse_two t in (Div (e1,e2), t')						      
    | OP::AND::t -> let (e1,e2,t') = parse_two t in (And (e1,e2), t')						   
    | OP::OR::t -> let (e1,e2,t') = parse_two t in (Or (e1,e2), t')
    | OP::EQ::t -> let (e1,e2,t') = parse_two t in (Eq (e1,e2), t')						    
    | OP::GT::t -> let (e1,e2,t') = parse_two t in (Gt (e1,e2), t')						    
    | OP::LT::t -> let (e1,e2,t') = parse_two t in (Lt (e1,e2), t')
    | OP::WHILE::t -> let (e1,e2,t') = parse_two t in (While (e1,e2), t')
    | OP::APP::t -> let (e1,e2,t') = parse_two t in (Apply (e1,e2), t')
    | OP::FUN::(ID s)::COLON::t ->
       let (tExp, t') = parse_type_expr t in
       let (bExp,t'') = parse_single t' in (Fun (s,tExp,bExp),t'')
    | OP::LET::(ID s)::t -> let (v,e,t') = parse_two t in (Let (s,v,e), t')
    | OP::SET::(ID s)::t -> let (e,t') = parse_single t in (Set (s,e), t')
    | OP::IF::t ->
       let (c,t1) = parser t in
       let (thn,els,t2) = parse_two t1 in (If (c,thn,els), t2)
    | OP::NOT::t -> let (e,t') = parse_single t in (Not(e),t')
    | OP::PRINT::t -> let (e,t') = parse_single t in (Print(e), t')
    | READINT::t -> (Readint, t)
    | OP::SEQ::t -> let (l,t') = parse_list t in (Seq(l),t')
    | _ -> failwith "Unexpected token: unbalanced parentheses or keyword out of call position"
       
  and parse_single t = let (e,t') = parser t in  (* parse a single expression and "eat" the following close paren *)
    ( match t' with
      | CP::t'' -> (e,t'')
      | _ -> failwith "parser: missing closing paren.")			 
      
  and parse_two t = (* "eat" the close paren after two expressions *)
    let (e1,t1) = parser t in
    let (e2,t2) = parser t1 in
    ( match t2 with
      | CP::t' -> (e1,e2,t')
      | _ -> failwith "parser: missing closing paren.")
      
  and parse_list t = (* parse a list of expressions, consuming the final closing paren *)
    ( match t with
      | CP::t' -> ([],t')
      | [] -> failwith "unfinished expression sequence: missing close paren(s)."
      | _ -> let (e,t1) = parser t in
	     let (el,t2) = parse_list t1 in (e::el, t2)
    )	
  in
  let (e,t) = parser tlist in
  match t with
  | [] -> e
  | _ -> failwith "parse failed: extra tokens in input."

(* insert definition of const_fold here *)
let rec const_fold exp = match exp with
  | Const n -> Const n
  | Boolean b -> Boolean b
  | Add (e1,e2) -> evalInt (+) e1 e2 
  | Mul (e1,e2) -> evalInt ( * ) e1 e2 
  | Sub (e1,e2) -> evalInt (-) e1 e2 
  | Div (e1,e2) -> evalInt (/) e1 e2 
  | If (cond,thn,els) -> evalIf cond thn els  
  | Let (nm,vl,exp') -> evalLet nm vl exp' 
  | Name nm -> Name nm 
  | And (e1,e2) -> evalBool (&&) e1 e2 
  | Or (e1,e2) -> evalBool (||) e1 e2 
  | Not e -> let b = const_fold e in (match b with
                                | Boolean x -> Boolean (not x)
				                | _ -> Not b ) 
  | Lt (e1, e2) -> evalComp (<) e1 e2 
  | Eq (e1, e2) -> evalComp (=) e1 e2 
  | Gt (e1, e2) -> evalComp (>) e1 e2 
  | Seq elist -> evalSeq elist 
  | While (cond,body) -> evalWhile cond body 
  | Set (name, e) -> let vl = const_fold e in Set (name, vl)
  | Fun (argname,x,body) -> Fun (argname,x, const_fold body)
  | Apply (f,e) -> Apply (const_fold f, const_fold e)
  | Readint  -> Readint
  | Print e -> let r = const_fold e in
	        Print r 

and evalInt f e1 e2 =
  let i1 = const_fold e1 in
  let i2 = const_fold e2 in
  match f,i1,i2 with
  | (+), Const x, Const y -> Const ((+) x y)
  | (-), Const x, Const y -> Const ((-) x y)
  | ( * ), Const x, Const y -> Const (( * ) x y)
  | (/), Const x, Const y -> Const ((/) x y) 
  | (+),_,_ -> Add (i1,i2)
  | ( * ),_,_ -> Mul (i1,i2)
  | (-),_,_ -> Sub (i1,i2)
  | (/),_,_ -> Div (i1,i2)
 
and evalIf cond thn els =
  let b = const_fold cond in
  match b with
  | Boolean true -> const_fold thn
  | Boolean false -> const_fold els
  | _ -> If (b, const_fold thn, const_fold els )

and evalLet name vl exp =
  let r = const_fold vl in
  let r' = const_fold exp  in
  match r,r' with
  | Const x, Const y -> Const y
  | Boolean x, Boolean y -> Boolean y 	
  | _ -> Let (name, r, r')

and evalBool f e1 e2 =
  let b1 = const_fold e1 in
  let b2 = const_fold e2 in
  match f,b1,b2 with 
  | (&&), Boolean x, Boolean y -> Boolean ((&&) x y)
  | (||), Boolean x, Boolean y -> Boolean ((||) x y) 
  | (&&),_,_ -> And (b1,b2) 
  | (||),_,_ -> Or (b1,b2)
 
and evalComp cmp e1 e2 =
  let r1 = const_fold e1 in
  let r2 = const_fold e2 in
  match cmp,r1,r2 with
  | (<), Const x, Const y -> Boolean ((<) x y)
  | (=), Const x, Const y -> Boolean ((=) x y)  
  | (>), Const x, Const y -> Boolean ((>) x y)
  | (<),_,_ -> Lt (r1,r2)
  | (=),_,_ -> Eq (r1,r2)   
  | (>),_,_ -> Gt (r1,r2)
  
and evalSeq elist =  match elist with 
  | [] -> Seq []
  | e::[] -> let w = const_fold e in w
  | _::_ ->  let rec helper lst acc = match lst with
				| e::[] -> let cfe = const_fold e in Seq ( acc@[cfe] )
				| h::t ->  let cfh = const_fold h in match cfh with
				            | Const x -> helper t acc
				            | Boolean x -> helper t acc
				            | _ -> helper t ( acc@[cfh] ) 
     			in helper elist []

and evalWhile cond body = 
  let b = const_fold cond in
  match b with 
   | Boolean false -> Seq []
   | _ -> let bod = const_fold body in
	 While (b,bod) ;;
 

(* Read the program from a filename provided on the command line*)
if Array.length Sys.argv < 2 then () else
  let infile = open_in Sys.argv.(1) in
  let first_line = input_line infile in (* Allow the unix #! trick on the first line, just for fun *)
  let rec read_loop acc =
    let next_line = try Some (input_line infile) with End_of_file -> None in
    match next_line with
    | Some s -> read_loop (acc^"\n"^s)
    | None -> acc in
  let progString = read_loop (if (String.length first_line > 2) && (String.sub first_line 0 2) = "#!" then "" else first_line) in
  (* Parse the program...*)
  let progExpr = progString |> wordlist |> tokens |> parse_program in
     
  (* Type check the program; we don't actually care about its type, just that it is valid. *)
  let _ = typeof ( const_fold progExpr ) [] in 
  (* call const_fold on progExpr here. Change the previous line so you can check the type of const_fold progExpr*) 
  (* Run the program. *)
  let cfoldprogExpr = const_fold progExpr in 
  let _ = ( eval cfoldprogExpr ) [] in () (* change progExpr to whatever name you bound to (const_fold progExpr) above *)

