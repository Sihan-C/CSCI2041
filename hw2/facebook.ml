(* A hypothetical scaled-down "database" structure for a social network. *)
type user_id = UID of int
type user = { id: user_id ; name : string ; private_data : string ; friends : user_id list }
type post_id = PID of int
type wall_post = { pid : post_id ; uid : user_id ; contents: string }
type database = { users : user list ; wall_posts : wall_post list }

let harry = { id = (UID 1) ; name = "Harry Potter" ; private_data = "The Chosen One" ;
	      friends = [ (UID 2) ; (UID 3) ] }
let hermione = { id = (UID 2) ; name = "Hermione Granger" ; private_data = "Hogwarts: A History" ;
		 friends = [ (UID 1) ; (UID 3) ] }
let ron = { id = (UID 3) ; name = "Ronald Weasley" ; private_data = "Er, what now?" ;
	    friends = [ (UID 1) ; (UID 2) ] }
let viktor = { id = (UID 4) ; name = "Viktor Krum" ; private_data = "Wronksi Feint" ;
	       friends = [ (UID 2) ; (UID 5) ] }
let igor = { id = (UID 5) ; name = "Igor Karkaroff" ; private_data = "Former Death Eater" ;
	     friends = [ (UID 4) ] }

let hermiones_post = { pid = (PID 1); uid = (UID 2) ; contents = "I read about it in Hogwarts: A History" }
let harrys_post = { pid = (PID 2) ; uid = (UID 1) ; contents = "Horcruxes are hard to find!" }
let viktors_post = { pid = (PID 3) ; uid = (UID 4) ; contents = "Quidditch is better than football." }
let rons_post = { pid = (PID 4) ; uid = (UID 3) ; contents = "Magic is cool." }
let harrys_second_post = { pid = (PID 5) ; uid = (UID 1) ; contents = "I dunno, I kinda miss he-who-shall-not-be-named." }

let hw = { users = [harry; hermione; ron] ; wall_posts = [hermiones_post ; harrys_post ; rons_post ; harrys_second_post ] }
let ds = { users = [viktor ; igor ] ; wall_posts = [ viktors_post ] }

	   
(* Function check_wp *)
let rec check_wp x = function 
  | [] -> false
  | h::t -> if h.id = x.uid then true
            else check_wp x t


(* Function check_friends *)
(* Two mutually recursive functions, check_friend_list and check_list 
   where check_friend_list go through each element in the friend list 
   and it calls check_list to see if that element is in the user list.*)
let check_friends x l = 
   if x.friends = [] then false
   else 
    let rec check_friend_list a b = match a with 
      | [] -> true
      | h::t -> check_list h b t
    and check_list h b t = match b with 
      | [] -> false   
      | h1::t1 -> if h1.id = h then check_friend_list t b   (* If we find one match, then keep goint with the rest of the friend list *)
                 else check_list h t1 t         (* Otherwise keep searching the possible matching element in the user list.  *)      
    in check_friend_list ( x.friends ) l 

(* Function check_db *)
let rec check_db x = match (x.wall_posts), (x.users) with 
  | [],[] -> true
  | [], h1::t1 -> true && check_friends h1 x.users
  | h::t, [] -> check_wp h (x.users) && true 
  | h::t, h1::t1 -> check_wp h (x.users) && check_friends h1 x.users
   








