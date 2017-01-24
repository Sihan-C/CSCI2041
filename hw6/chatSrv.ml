open Lwt

module Server = struct
    (* a list associating user nicknames to the output channels that write to their connections *)
    (* Once we fix the other functions this should change to []*)
    let sessions = ref [("",Lwt_io.null)]	     
    exception Quit
		
    (* replace Lwt.return below with code that uses Lwt_list.iter_p to 
       print sender: msg on each output channel (excluding the sender's)*)
    let rec broadcast sender msg = 
		Lwt_list.iter_p (fun (a,b) -> if a = sender then Lwt.return () 
			else Lwt_io.write_line b (sender^": "^msg)) !sessions   

    (* remove a session from the list of sessions: important so we don't try to 
       write to a closed connection *)
    let remove_session nn = 
      sessions := List.remove_assoc nn !sessions;
      broadcast nn "<left chat>" >>= fun () ->
      Lwt.return ()

    (* Modify to handle the "Quit" case separately, closing the channels before removing the session *)
    let handle_error e nn inp outp = match e with 
		| Quit -> Lwt_io.close inp >>= fun () -> Lwt_io.close outp >>= fun() -> remove_session nn 
		| _ -> remove_session nn
    (* modify sessions to remove (nn,outp) association, add (new_nn,outp) association.
       also notify other participants of new nickname *)
    let change_nn nn outp new_nn = 
	broadcast !nn ("<changed nick to "^new_nn^">") >>= 
	fun () -> sessions := List.map (fun (k,v) -> if k = !nn then (new_nn,v)
	 else (k,v)) !sessions; nn := new_nn; Lwt.return()
			
    let chat_handler (inp,outp) =
      let nick = ref "" in
      (* replace () below with code to 
         + obtain initial nick(name), 
         + add (nick,outp) to !sessions, and 
         + announce join to other users *) 
      let _ = Lwt_io.write outp "Enter initial nick: " >>=
	  fun () -> Lwt_io.read_line inp >>= fun s -> nick := s; 
	  sessions := (!nick,outp)::!sessions;
	  broadcast !nick "<joinded>" in
      (* modify handle_input below to detect /q, /n, and /l commands *)
      let handle_input l =  match Str.string_before l 2 with
		| "/q" -> raise Quit
		| "/n" -> let x = Str.string_after l 3 in change_nn nick outp x
		| "/l" -> Lwt_list.iter_s (fun (k,v) -> Lwt_io.write_line outp k) !sessions
		| _ -> broadcast !nick l in
      let rec main_loop () =
	Lwt_io.read_line inp >>= handle_input >>= main_loop in
      Lwt.async (fun () -> Lwt.catch main_loop (fun e -> handle_error e !nick inp outp))
  end

let port = if Array.length Sys.argv > 1 then int_of_string (Sys.argv.(1)) else 16384		  
let s = Lwt_io.establish_server (Unix.ADDR_INET(Unix.inet_addr_any, port)) Server.chat_handler	    
let _ = Lwt_main.run (fst (Lwt.wait ()))
let _ = Lwt_io.shutdown_server s (* never executes; you might want to use it in utop, though *)
