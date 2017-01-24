(* hostinfo, the "name" of a computer connected to the Internet *)
type hostinfo = IP of int*int*int*int | DNSName of string

(* Here's where your definition of tld goes: *)
(* Function tld takes one argument, type hostinfo and return hostinfo option type. 
   Three String functions, String.length, String.subs and String.rindex, are used. 
   s is the start index of TLD, +1 since String.rindex x '.' return the index of '.',
   which is right before the TLD. and String.length (x) -s return the length of TLD. *)
let tld = function
  | IP _ -> None
  | DNSName x -> let s = ( String.rindex x '.') + 1 in 
                Some ( String.sub x s ( String.length ( x ) - s ) ) 
   
