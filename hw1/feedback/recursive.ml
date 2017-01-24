(* TA COMMENT(zhan4136): 20/20 *)

(* Function range *)
(* A nested function tail_range is used to accomplished the requirement                                                                                                                      
   of tail recursion, and we going through the integers in range in reverse                                                                                                                  
   order, since the result list of the accumulator will be in reversed order. *)
let range a b =
  let rec tail_range x accum =
        if x < a then accum
        else tail_range (x-1) (x::accum)
  in tail_range (b-1) []


(* Function range_step *)
(* Same as the last function, a nested function is used to achieve tail recursion.                                                                                                           
   and that function has been separated into three cases. which is when step is 0 , smaller                                                                                                  
   than 0 or larger than 0. In the last line List.rev() is used to reverse the list since the                                                                                                
   accumulator in tail recursion collect results in reverse order. *)
let range_step a b c=
  let rec tail_range_step x accum =
        if c = 0 then []
        else if c >0 then
            if x >= b then accum      (* Here x = b is to agree with the python standard *)
            else tail_range_step (x+c) (x::accum)
        else
            if x <= b then accum      (* Here x = b is to agree with the python standard *)
            else tail_range_step (x+c) (x::accum)
  in List.rev( tail_range_step a [])


(* Function take *)
(* The function has three cases, which are n is negative, 0 or positive. We can not say first negative number                                                                                
   element, so the way we deal with this is raise an exceptions. When n is 0, simply return an empty list.                                                                                   
   For the n is positive case, same method is used as last two fuctions to achieve tail recursion. *)
let take a b =
    if a < 0 then invalid_arg "take: negative argument"
    else if a = 0 then []
    else
      let rec tail_take x l accum = match l with
        | [] -> accum
        | f::t -> if x > 0 then tail_take (x-1) t (f::accum)
          else accum
      in List.rev(tail_take a b [])

