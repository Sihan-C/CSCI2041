type 'a lazylist = LzCons of 'a * 'a lazylist lazy_t | EmptyLL
let (@@) h t = LzCons(h,t)

let rec lztake n ll = match (n,ll) with
  | (0,_) | (_,EmptyLL) -> []
  | (_,LzCons(h,t)) -> h::(lztake (n-1) (Lazy.force t))

let rec eq_ll l1 l2 = match (l1,l2) with
  | (EmptyLL,EmptyLL) -> true
  | (_,EmptyLL) | (EmptyLL,_) -> false
  | (LzCons(h1,t1), LzCons(h2,t2)) -> (h1=h2) && (eq_ll (Lazy.force t1) (Lazy.force t2))
     
(* put your lazylist functions right here: *)
(* Function lzmap *)
let rec lzmap f lst = match lst with
	| EmptyLL -> EmptyLL
	| LzCons(x,y) -> LzCons((f x), lazy( lzmap f (Lazy.force y) ) )
	
(* Function lzfillter *)
let rec lzfilter f lst = match lst with
	| EmptyLL -> EmptyLL
	| LzCons(x,y) -> if (f x) then LzCons(x, lazy( lzfilter f (Lazy.force y) ) ) 
					 else lzfilter f (Lazy.force y) 
					 
(* Function lznatpairs *)
let rec lznatpairs x = match x with
	| (a,0) -> LzCons (x, lazy( lznatpairs (0,a+1))) 
	| (a,b) -> LzCons (x, lazy( lznatpairs (a+1,b-1)))
	  		
		    
(* a w-ary tree type for question 4 part 2 *)		     
type 'a wtree = Node of 'a wtree list | Leaf of 'a 

(* non-lazy breadth-first search *)						  
let bfs t =
  let rec bfs_h tlst =
    match tlst with
    | [] -> []
    | (Leaf v)::t -> v::(bfs_h t)
    | Node(l)::t -> bfs_h (t@l)
  in bfs_h [t]

(* a demonstration. uncomment these lines and try this in utop: (bfs t1) = (bfs t2) *)
let deeptree n x =
  let rec dtree i k =
    if i = 0 then k (Leaf x)
    else dtree (i-1) (fun r -> k (Node [r]))
  in dtree n (fun x -> x)

let yikes = deeptree (1 lsl 3) 7 	   
let t1 = Node [Leaf 4; yikes; Leaf 5]
let t2 = Node [Leaf 4; yikes; Leaf 6] 

(* Now add lazy_bfs here, and try (eq_ll (lazy_bfs t1) (lazy_bfs t2)) in utop *)
(* Function lazy_bfs *)
let lazy_bfs t =
	let rec lzbfs_h tlst rst = match tlst with 
		| [] -> Lazy.force rst
		| (Leaf v)::t -> LzCons( v, lazy (lzbfs_h t rst))
		| Node(l)::t -> lzbfs_h (t@l) rst
	in lzbfs_h [t] (lazy EmptyLL)	





