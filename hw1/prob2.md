#Problem 2

1.  Legal:   Type: int  ;   Value: 5
2.  Illegal:  Since * operator is for integer multiplication in ocaml. So the expression is expected to have a type int, but it use 3.14, a float, as a operand. So the expression has type float, so it is illegal. 
3.  Illegal:  Since the expression between if and then should be a bool type, but in the expression provided, it used an int type. So it is illegal. 
4.  Illegal:  Since two expressions on the if and else branches disagree with each other. It should be a int type in the else branch, but the expression provided has a string type, so illegal. 
5.  Illegal:  Since the assumption of there are no bindings preceding these expressions, then the y will be unbound. it will have an unbound value, so illegal. 
6.  Illegal:  Since based on the *. operator, we know that the argument d of the function circ should be a float type value, but in the body of the expression, it try to pass 4, a int value to function circ. So it is illegal. 
7.  Legal:    Type: float ;   Value: 12.56
8.  Legal:    Type: int ;   Value: 7
9.  Legal:    Type: string ;  Value: "cheezz"
10.  Illegal:  Based on the operator in the body of the expression x+y, it should return an int type value. but y is a turple of type int*string. So it is illegal.  
