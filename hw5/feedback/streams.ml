(* data type to represent an infinite data object in a "lazy" fashion *)
type 'a stream = Cons of 'a * (unit -> 'a stream)

(* Some utility functions for streams *)				
let hd (Cons(h,t)) = h
let tl (Cons(h,t)) = t ()

let rec take_s n s = match (n,s) with
| (0,_) -> []
| (_,Cons(h,t)) -> h::(take_s (n-1) (t ()))

let rec map_s f (Cons(h,t)) = Cons(f h, fun () -> map_s f (t ()))			
			
let rec merge s1 s2 = Cons(hd s1, fun () -> Cons(hd s2, fun () -> merge (tl s1) (tl s2)))

let rec filter_s p (Cons(h,t)) =
  if (p h) then Cons(h, fun () -> filter_s p (t ()))
  else filter_s p (t ())
			  
let double s = merge s s 

(* Some streams we have seen in lecture *)		     
let rec nats n = Cons(n, fun () -> nats (n+1))
let fibs = let rec fib_help f0 f1 = Cons(f0, fun () -> fib_help f1 (f0+f1)) in fib_help 0 1
let factorials = let rec fact_help n a = Cons(n*a, fun () -> fact_help (n+1) (n*a)) in fact_help 1 1

(* one more helpful function *)
let rec gcd a b =
  if a=0 then b
  else if b < a then gcd b a
  else gcd (b mod a) a
	   
(* Your solutions for problem 3 go here: *)
	   
(* function natpairs *)
let rec natpairs (x:int*int) = match x with 
	| (a,0) -> Cons (x, (fun () -> natpairs (0,a+1))) 
	| (a,b) -> Cons (x, (fun () -> natpairs (a+1,b-1)))

(* function py_triple and py_check *)
let rec py_triple (x:int*int) = match x with
	| (a,b) -> (a,b, int_of_float(floor (sqrt (float_of_int (a*a+b*b)))))

let rec py_check (x:int*int*int) = match x with
	| (a,b,c) -> if a > b then false
				 else if a*a+b*b!=c*c then false 
				 else if gcd a b !=1 then false 
				 else true 

(* function pytrips *)
let pytrips = filter_s py_check (map_s py_triple ( natpairs ((1,1)) ))

(* TA COMMENT(moham775) natpairs: 6/6 *)
(* TA COMMENT(moham775) py_triple: 3/3 *)
(* TA COMMENT(moham775) check_py: 3/3 *)
(* TA COMMENT(moham775) pytrips: 3/3 *)	

(* A helper function explode, take in a string, turn in to a list *)
let explode s = 
  let rec helper x l =
	if x < 0 then l else helper (x-1) ( (Char.lowercase (s.[x]))::l)
  in helper (String.length s - 1) []

(* function pal_check *)
let pal_check s = List.rev( explode s ) = explode s	 

(* function kleene_star *)
let kleene_star lst = 
    let rec helper lst inlst q = match q with 
    	| [] -> Cons("", (fun () -> helper lst inlst (q@[""]) ))   
	| h::qt -> let rec helper1 lst inlst qt = (match lst with 
		   | [] -> helper inlst inlst qt 
		   | h1::t1 -> Cons( h1^h, (fun() -> helper1 t1 inlst (qt@[h1^h]))))
	in helper1 lst inlst qt
    in helper lst lst [] 

(* function palindromes *)
let palindromes lst = filter_s (pal_check) (kleene_star lst)


(* TA COMMENT(zhan4136) pal_check: 4/4 *)

(* TA COMMENT(zhan4136) kleene_star: 8/8 *)

(* TA COMMENT(zhan4136) palindromes: 3/3 *)

 		 



