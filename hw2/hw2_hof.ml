(* Function assoc_by *)
let rec assoc_by f lst = match lst with
  | [] -> None
  | (k,v)::t -> if f k then Some v
                else assoc_by f t  

(* Function assoc_eq *)
let rec assoc_eq x fun1 lst= match lst with
  | [] -> None
  | (k,v)::t -> if fun1 (x:'a) (k:'a) then Some v
                else assoc_eq x fun1 t    

(* Function assoc_by_eq *)
let rec assoc_by_eq  p lst = 
    match lst with 
    | [] -> None
    | (k,v)::_ -> assoc_eq k (fun x y -> p y ) lst  (* Change fun x y from taking 2 arguments to only 1. *)
       
(* Function assoc_eq_by *)
let rec assoc_eq_by x fun1 lst = match lst with
  | [] -> None
  | (k,v)::_ -> assoc_by (fun w -> fun1 (x:'a) (w:'a) ) lst 
