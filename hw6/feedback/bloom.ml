(* Bloom Filter implementation.  This file will not compile as is. *)
module type memset = sig
    type elt (* type of values stored in the set *)
    type t (* abstract type used to represent a set *)
    val mem : elt -> t -> bool 
    val empty : t
    val is_empty : t -> bool
    val add : elt -> t -> t
    val from_list : elt list -> t
    val union : t -> t -> t
    val inter : t -> t -> t
  end

(* Define the hashparam signature here *)		       
module type hashparam = sig
	type t
	val hashes : t -> int list
  end

(* Define SparseSet module here, using the Set.Make functor *)			  
module SparseSet : memset with type elt = int = struct
	include Set.Make(struct type t = int let compare = Pervasives.compare end)
  (* Implementation of from_list *)
	let from_list lst = List.fold_left (fun s e -> add e s) empty lst 
  end

(* Fill in the implementation of the memset signature here.  You'll need to expose the elt type *)		       
module BitSet : memset with type elt = int = struct
	type elt = int 
	type t = string
	(* Function from memset interface*)	
	let rec mem i s = ( String.length s > (i/8) ) && ((Char.code s.[i/8]) land (1 lsl (i land 7)) <> 0)  
	let empty = ""
	let is_empty s = match s with
		| "" -> true
		| _ -> false
  (* single-character string with bit i set: *)
  let strbit i = String.make 1 (Char.chr (1 lsl (i land 7)))  
  (* function make_str_t *)
  let rec make_str_t i s = if (i<8) then s^strbit i else make_str_t (i-8) ("\000"^s)   
  (* Some helper functions... bitwise &, bitwise | of two char values: *)
  let (&*) c1 c2 = String.make 1 (Char.chr ((Char.code c1) land (Char.code c2)))
  let (|*) c1 c2 = String.make 1 (Char.chr ((Char.code c1) lor (Char.code c2)))	  
  (* bitwise or of two strings: *)
  let rec (|@) s1 s2 = match (s1,s2) with
    | ("",s) | (s, "") -> s
    | _ -> (s1.[0] |* s2.[0]) ^ ((Str.string_after s1 1) |@ (Str.string_after s2 1))
	(* bitwise and of two strings: *)
	let rec (&@) s1 s2 = match (s1,s2) with
	  | ("",s) | (s,"") -> s
	  | _ -> (s1.[0] &* s2.[0]) ^ ((Str.string_after s1 1) &@ (Str.string_after s2 1))
  let add e s = make_str_t e "" |@ s
  let union s1 s2 = s1 |@ s2
  let inter s1 s2 = s1 &@ s2 
  let from_list lst = List.fold_left (fun s e -> add e s) empty lst 
  end

(* Fill in the implementation of a BloomFilter, matching the memset signature, here. *)
(* You will need to add some sharing constraints to the signature below. *)
module BloomFilter(S : memset with type elt = int)(H : hashparam) : memset
	with type elt = H.t
  = struct
  type elt = H.t
  type t = S.t
  (* Implement the memset signature: *)
	let mem e s = List.fold_left (fun acc x -> if S.mem x s then true && acc else false && acc ) true (H.hashes e)
	let empty = S.empty
	let is_empty s = S.is_empty s
	let add e s = List.fold_left (fun acc x -> S.add x acc ) s (H.hashes e)
	let from_list lst = List.fold_left (fun s e -> add e s) S.empty lst 
	let union s1 s2 = S.union s1 s2
	let inter s1 s2 = S.inter s1 s2
  end

(* TA COMMENT(dacos014): 

   * 2.0 / 2.0 pts for correct definition. This means using memset (0.5), hashparam (0.5)
     and setting elt type to that of hashparam's t (0.5). Additional 0.5 for overall correct definition.
   * 0.5 / 0.5 pts for correct t and elt types.
   * 0.5 / 0.5 pts for correct union declaration.
   * 0.5 / 0.5 pts for correct inter declaration.
   * 1.0 / 1.0 pts for correct mem declaration.
   * 0.5 / 0.5 pts for using memset's empty as empty.
   * 0.5 / 0.5 pts for using memset's is_empty as is_empty.
   * 2.0 / 2.0 pts for correct add function. This means using memset's add (0.5), hashparam's hashes (0.5),
     as well as list.fold_left (0.5). Additional 0.5 for overall correct function.
   * 2.5 / 2.5 pts for correct from_list declaration. **Maximum 1.5 pts for attempt.**
   
*)

(* A hashparam module for strings... *)
module StringHash = struct
    type t = string (* I hash values of type string *)
    let hlen = 15
    let mask = (1 lsl hlen) - 1
    let hashes s =
      let rec hlist n h = if n = 0 then [] else (h land mask)::(hlist (n-1) (h lsr hlen)) in
      hlist 4 (Hashtbl.hash s) 
  end

(* Add the IntHash module here *)
module IntHash = struct
    type t = int (* I hash values of type int *)
    let hashes n =
		[ (795*n+962) mod 1031; (386*n+517) mod 1031; (937*n+693) mod 1031 ]
  end

(* TA COMMENT(moham775): Int Hash: 5/5 *)





(* TA Comment(meye2058) BitSet Module Feedback: 10/10 *)
