(* Function csvify *)
(* Function csvify take a string * string tuple and return a concatenated string of 
   x, a comma and y *)
let csvify (x,y) = x ^ ", " ^ y 
   
(* Function ++ *)
(* Function ++ take two intger argument x and y and return an int value, with largest number
   be 32767 and smallest number be -32768 *)
let (++) x y = if x + y > 32767 then 32767
               else if x + y < -32768 then -32768
               else x+y   
     
(* Function vec_add *)
(* Function vec_add take in two float tuples add their corresponding element together and then
   return a single float tuple *)
let vec_add (a,b) (c,d) = a+.c, b+.d  

(* Function dot *)
(* Function dot take in two float tuples and multiply their corresponding element together 
   and return a single float tuple  *)
let dot (a,b) (c,d) = a*.c +. b *. d

(* Function perp *)
(* Function perp take in two float tuples and return a bool value  *)
let perp (a,b) (c,d) = if a *. c +. b *. d = 0. then true else false 

(* TA COMMENT(halto004):
  Looks good.
  20/20

*)
