###take 3 (squares 3)
```
The expression will reach a normal form in a finite number of steps
take 3 (squares 3)
take 3 (9::(squares 4))
9::(take 2 (squares 4))
9::(take 2 (16::(squares 5)))
9::16::(take 1 (squares 5))
9::16::(take 1 (25::(squares 6)))
9::16::25::(take 0 (squares 6))
9::16::25::[]
```

### fold_right (&&) (map ((<) 0) (squares 2)) true
```
The expression will never reach a normal form under lazy evaluation
fold_right (&&) (map ((<) 0) (squares 2)) true
fold_right (&&) (map ((<) 0) (4::(squares 3))) true
fold_right (&&) (((<) 0) 4)::(map ((<) 0) (squares 3)) true
fold_right (&&) true::(map ((<) 0) (squares 3)) true
(&&) true (fold_right (&&) (map ((<) 0) (squares 3)) true)
(&&) true (fold_right (&&) (map ((<) 0) (9::(squares 4))) true)
(&&) true (fold_right (&&) (((<) 0) 9)::(map ((<) 0) (squares 4)) true
(&&) true (fold_right (&&) true::(map ((<) 0) (squares 4)) true
(&&) true ((&&) true (fold_right (map ((<) 0) (squares 4)) true)
Since in the later derivation, it will check whether squares 4,squares 5,.... are larger than 0, which will always be true
because of the definition of square. We will get a infinite sequence of true connected with &&. So there will not exist an short circuit to end the evaluation, the evaluation will running forever.    
.....
```


### fold_right (||) (map (fun n -> n mod 8 = 0) (factorials ())) false
```
The expression will reach a normal form in a finite number of steps
fold_right (||) (map (fun n -> n mod 8 = 0) (factorials ())) false
fold_right (||) (map (fun n -> n mod 8 = 0) (1::(fac_acc 2 1)) false
fold_right (||) ((fun n -> n mod 8 = 0) 1)::(map (fun n -> n mod 8 = 0) (fac_acc 2 1)) false
fold_right (||) false::(map (fun n -> n mod 8 = 0) (fac_acc 2 1)) false
(||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (fac_acc 2 1)) false)
(||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (2::(fac_acc 3 2))) false)
(||) false (fold_right (||) ((fun n -> n mod 8 = 0) 2)::(map (fun n -> n mod 8 = 0) (fac_acc 3 2)) false)
(||) false (fold_right (||) false::(map (fun n -> n mod 8 = 0) (fac_acc 3 2)) false)
(||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (fac_acc 3 2)) false))
(||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (6::(fac_acc 4 6))) false))
(||) false ((||) false (fold_right (||) ((fun n -> n mod 8 = 0) 6)::(map (fun n -> n mod 8 = 0) (fac_acc 4 6)) false))
(||) false ((||) false (fold_right (||) false::(map (fun n -> n mod 8 = 0) (fac_acc 4 6)) false))
(||) false ((||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (fac_acc 4 6)) false)))
(||) false ((||) false ((||) false (fold_right (||) (map (fun n -> n mod 8 = 0) (24::(fac_acc 5 24))) false)))
(||) false ((||) false ((||) false (fold_right (||) ((fun n -> n mod 8 = 0) 24)::(map (fun n -> n mod 8 = 0) (fac_acc 5 24)) false)))
(||) false ((||) false ((||) false (fold_right (||) true::(map (fun n -> n mod 8 = 0) (fac_acc 5 24)) false)))
(||) false ((||) false ((||) false ((||) true (fold_right (||) (map (fun n -> n mod 8 = 0) (fac_acc 5 24)) false))))
(||) false ((||) false ((||) false true))
(||) false ((||) false true)
(||) false true
true

```

### take (sum_list (squares 1)) (factorials ())
```
The expression will never reach a normal form under lazy evaluation
take (sum_list (squares 1)) (factorials ())
take (sum_list (squares 1)) (1::(fac_acc 2 1))
1::(take ((sum_list (squares 1))-1) (fac_acc 2 1))
1::(take ((sum_list (1::(squares 2)))-1) (fac_acc 2 1))
1::(take (1+(sum_list (squares 2))-1) (fac_acc 2 1))
1::(take (sum_list (squares 2)) (fac_acc 2 1))
1::(take (sum_list (squares 2)) (2::(fac_acc 3 2)))
1::2::(take ((sum_list (squares 2))-1) (fac_acc 3 2))
1::2::(take ((sum_list (4::(squares 3)))-1) (fac_acc 3 2))
1::2::(take (4+(sum_list (squares 3))-1) (fac_acc 3 2))
1::2::(take (3+(sum_list (squares 3))) (fac_acc 3 2))
1::2::(take (3+(sum_list (squares 3))) (6::(fac_acc 4 6)))
1::2::6::(take (3+(sum_list (9::(squares 3)))-1) (fac_acc 4 6))
1::2::6::(take (12+(sum_list (squares 3))-1) (fac_acc 4 6))
1::2::6::(take (11+(sum_list (squares 3))) (fac_acc 4 6))
it will be infinite because the first parameter of take will keep increasing, so this expression will never reach a normal form under lazy evaluation.   
....
```
