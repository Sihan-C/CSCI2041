(* Types for binary search trees. *)
type 'a btree = Node of 'a * 'a btree * 'a btree | Empty

(* A comparison function cmp should have the following behavior:
   - cmp x y < 0 if x is less than y
   - cmp x y = 0 if x is equal to y
   - cmp x y > 0 if x is greater than y *)
type 'a compare = 'a -> 'a -> int

(* A binary search tree is a binary tree where every element in the 
   left subtree of Node(x,left,right) is less than x, 
   and every element in the right subtree is greater than x. *)
type 'a bstree = { tree : 'a btree ; cmp : 'a compare }

(* just a helper function for building trees *)		   
let leaf x = Node(x,Empty,Empty)
		 
let search { tree ; cmp } v =
  let rec tsearch t = 
    match t with
    | Empty -> false
    | Node (v',lt,rt) ->
       match (cmp v v') with
       | 0 -> true
       | s when s < 0 -> tsearch lt
       | _ -> tsearch rt
  in tsearch tree

let insert { tree ; cmp } v =
  let rec tinsert t =
    match t with
    | Empty -> (leaf v)
    | Node (v',lt,rt) ->
       match (cmp v v') with
       | 0 -> t
       | s when s < 0 -> Node(v', (tinsert lt), rt)
       | _ -> Node(v', lt, (tinsert rt)) in
  { tree = (tinsert tree) ; cmp }


(* Function treeMin *)
(* The first pattern matching is used to match the first node.
   A helper function searchMin is used, The base case of the pattern matching inside 
   the helper function is Empty, which means it reaches the child of a leaf. The iterative 
   case is a non empty tree. And for that pattern, there are two branches. if min, a variable used 
   stand for the minimum value in the checked nodes, is larger than the value of that node,nod, it is 
   currently examined, then pass nod as min parameter for the function searchMin to examine the left subtree of the
   node, then use that result as the min parameter to examine the right subtree. If min is smaller than
   node, then we still use min as the min parameter to pass to the helper function to examine left subtree. *)
let treeMin bt (f:'a compare) = match bt with
  | Empty -> None
  | Node (x ,lt, rt) -> let rec searchMin t min  = 
            match t with
            | Empty -> min
            | Node (nod,lt1,rt1) -> if ( f min nod ) > 0 then 
                                    let aftlt = searchMin lt1 nod in
			               searchMin rt1 aftlt  
                                    else let aftlt = searchMin lt1 min in
                                       searchMin rt1 aftlt  
                        in let x = searchMin lt x in 		              
                        Some (searchMin rt x)  


(* TA COMMENT(moham775): This function should be implemented by inverting the cmp function and using treeMin -3 *)
(* Function treeMax *)
(* treeMax and treeMin has almost the same definition. The difference are 1. if (max nod)> 0 is changed to <0 2. All the mins are changed to maxs  *)
let treeMax bt (f:'a compare) = match bt with
  | Empty -> None
  | Node (x ,lt, rt) -> let rec searchMax t max  =
            match t with
            | Empty -> max
            | Node (nod,lt1,rt1) -> if ( f max nod ) < 0 then
                                    let aftlt = searchMax lt1 nod in
                                       searchMax rt1 aftlt
                                    else let aftlt = searchMax lt1 max in
                                       searchMax rt1 aftlt
                        in let x = searchMax lt x in
                        Some (searchMax rt x)

(* TA COMMENT(moham775): 12/15 *)
(* Function check_bst: 
   A helper function check_bst is used, the helper function will return a turple, which its first element is 
   the bool value of that node placed. and the second element of the turple is the value of that node. The helper function
   takes in a binary search tree. And there are 5 kinds of trees that could match with that binary search tree. 1, empty tree
   2, a tree with only one node. 3. A tree with only left subtree. 4. A tree with only right subtree. 5. A tree with both right and left
   subtrees. And an empty tree is the base case. Since it doesn't have any right or left child. So I initially assign it with true as its 
   first argument. The reslt and resrt is the correctness (true as correct, false as incorrect)of the left subtree and right subtree respectively.
   numlt and numrt is the node of the left subtree and right subtree respectively. if the result from left and right subtree are both true and 
   all the nodes in x's right subtree are larger than x and nodes in its left subtree are smaller than x, then return true.Max and min are used to check 
   that the node that is currently examined is larger than all the nodes in its left subtree and smaller than all the nodes in its right subtree. *)
let check_bst {tree ; cmp}  = 
   let rec checkh t = match t with
     | Empty -> (true, 0)     
     | Node (x, Empty, Empty ) -> (true, x) 
     | Node (x, y , Empty ) -> let (reslt, numlt) = checkh y in let max = match (treeMax y cmp) with
                                            |None -> invalid_arg "Can't happen since it will not be an empty tree" | Some w -> w in ((numlt < x ) && reslt && (x > max), x ) 
     | Node (x, Empty, z) -> let (resrt, numrt) = checkh z in let min = match (treeMin z cmp) with  
                                            | None -> invalid_arg "Can't happen since it will not be an empty tree" | Some w -> w in ((numrt > x) && resrt && (x < min), x ) 
     | Node (x, y, z) -> let (reslt, numlt) = checkh y in let (resrt, numrt) = checkh z in let max = match (treeMax y cmp) with 
                                            |None -> invalid_arg "Can't happen since it will not be an empty tree"| Some w -> w in let min = match (treeMin z cmp) with 
                                            |None -> invalid_arg "Can't happen since it will not be an empty tree" | Some q -> q in 
                                                 ((x>numlt) && (x<numrt) && reslt && resrt && (x > max) && (x < min), x )
   in match (checkh tree) with
   | (x, _) -> x   (* We only need the bool value, x, in the turple. *)
   
     

(* Test cases *)
let tree1 = { tree = Node (5, Node (3, Node (1, Empty, Empty), Node (4, Empty, Empty)), Node (6, Empty, Node (7, Empty, Empty))) ; cmp = compare } 
let tree2 = { tree = Node (7, Node (4, Node (3, Empty, Empty), Node (6, Node (5, Empty, Empty), Empty)), Node (9, Node (8, Empty, Empty), Node (11, Empty, Empty))) ; cmp =compare }
let tree_err1 = { tree = Node (4, Node (6, Empty, Empty), Node (3, Node (5, Empty, Empty), Empty)); cmp = compare }
let tree_err2 = { tree = Node (7, Node (11, Empty, Empty), Node (5, Node (3, Empty, Empty), Node (20,Empty, Empty))) ; cmp = compare }
let () = assert ((check_bst tree1) = true)
let () = assert ((check_bst tree2) = true)
let () = assert (check_bst tree_err1 = false)
let () = assert (check_bst tree_err2 = false)
let () = assert (check_bst (insert tree1 2))
let tree3 = insert tree2 10 
let () = assert ((search tree3 10) = true )
let () = assert (treeMax (tree1.tree) (tree1.cmp) = Some 7) 
let () = assert (treeMin (tree2.tree) (tree2.cmp) = Some 3) 
  (*TA COMMENT(zhan2361): check_bst did not use treemin treemax 12/15*)