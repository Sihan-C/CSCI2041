
#Poly Proof 1

I need to prove the following property P(a1):
```
For all a1, a2 ∈ polyList, list_deg ( list_add a1 a2 ) = deg ( Add ( to_poly a1, to_poly a2 ) )
```

#### Base Case:
```
For base case, we want to show: P([]) : For all a2 ∈ polyList, 
list_deg ( list_add [] a2 ) <=> deg ( Add ( to_poly [], to_poly a2 ) )  
Proof: 
list_deg ( list_add [] a2 ) <=> list_deg ( match ([],a2) with    [ by subsitution ]
                                            | (p,[]) | ([],p) -> p
                                            | (a1::t1,a2::t2) -> (a1+a2)::(list_add t1 t2) )  
                            <=> list_deg a2    [ by evaluation ]
                            <=> match a2 with    [ by subsitution ]
                                  | [] -> 0
                                  | _ -> (List.length p) - 1
                            <=> (List.length a2) - 1, when a2 is not an empty list
                            <=> 0, when a2 is an empty list
deg ( Add ( to_poly [], to_poly a2 ) ) <=> max ( deg (to_poly [])  deg (to_poly a2) )    [by subsitution ]
                                       <=> max ( list_deg [] ) ( list_deg a2 )    [ by lemma provided in the hw ]
                                       <=> max 0 ( (List.length a2) - 1 ), when a2 is not an empty list    [by subsitution ]
                                       <=> max 0 0 <=> 0    [ by subsitution ]
      Since when a2 is not an empty list, list_deg ( list_add [] a2 ) <=> (List.length a2) - 1
      Where ( List.length a2 ) - 1 >= 0    [ the property of list and definition of List.length function ]
      So deg ( Add ( to_poly [], to_poly a2 ) ) <=> max 0 ( (List.length a2) - 1 ) <=>(List.length a2) - 1 <=>
      list_deg ( list_add [] a2 ) 
      When a2 is an empty list, deg ( Add ( to_poly [], to_poly a2 ) ) <=> max 0 0 <=> 0 <=> <=> list_deg ( list_add [] a2 )
So      list_deg ( list_add [] a2 ) <=> deg ( Add ( to_poly [], to_poly a2 ) )
So base case proved. 
```
#### Inductive Case:
```
We want to show that For all a1 ∈ polyList, P(a1): for all a2 ∈ polyList, 
list_deg (list_add a1 a2) <=> deg (Add (to_poly a1, to_poly a2)) ==> P(x::a1): for all a2 ∈ polyList,
list_deg (list_add (x::a1) a2) <=> deg (Add (to_poly (x::a1), to_poly a2))
```
##### Inductive Hypothesis:
```
For all a1 ∈ polyList, P(a1): for all a2 ∈ polyList, list_deg (list_add a1 a2) = deg (Add (to_poly a1, to_poly a2)) 
```
##### Inductive Case Proof:
```
list_deg (list_add (x::a1) a2) <=> list_deg ( match (x::a1,a2) with    [ by subsitution ]
                                            | (p,[]) | ([],p) -> p
                                            | (p1::t1,p2::t2) -> (p1+p2)::(list_add t1 t2) )   )
                               <=> list_deg ( (x+p2)::(list_add a1 t2 ) )    [ by evaluation of function list_deg ]  
                               <=> List.length ((x+p2)::(list_add a1 t2 )) - 1    [ by subsitution ]
                               <=> List.length ((list_add a1 t2)) + 1 - 1    [ by the definition of cons and function List.length ] 
                               <=> list_deg (list_add a1 t2) + 1    [ by definition of function list_deg ]
                               <=> deg (Add (to_poly a1, to_poly t2)) + 1    [ by inductive hypothesis ]
                               <=> max (deg ( to_poly a1 ) ) ( deg (to_poly t2)) + 1    [ by subsitution ]
                               <=> max ( list_deg a1 ) ( list_deg t2 ) + 1    [ by lemma provided in the hw ]
                               <=> max ( (List.length a1) - 1) (List.length t2) - 1 ) + 1    [ by subsitution ]
                               <=> max ( (List.length a1) - 1 + 1 ) ( (List.length t2) -1 + 1 )    [ by property of max ]
                               <=> max ( (List.length (x::a1) - 1) (List.length ( x::t2 ) - 1 )    [ by property of function List.length  ]
                               <=> max ( list_deg (x::a1) ) ( List.length (x::t2) )    [ by definition of function list_deg ]
  Since List.length (x::t2) = List.length (p2::t2) = List.length a2 
                               <=> max ( list_deg (x::a1) ) ( List.length a2 )
                               <=> deg ( Add (list_deg (x::a1)) (list_deg a2))    [ by definition of function deg ]
                               <=> deg ( Add (to_poly (x::a1)) (to_poly a2) )    [ by lemma provided in the hw ]
                               
  So inductive case proved. 
  So for all a1, a2 ∈ polyList, list_deg ( list_add a1 a2 ) = deg ( Add ( to_poly a1, to_poly a2 ) )
```

---
**TA COMMENT(dacos014)**:

- Your P should not quantify over the variable you are inducting over:
  -1
- The base case should not include the case analysis of a2; you
  inductive case should: -1

total - 8/10
---



#Poly Proof 2
I need to prove the following property P(p1):
```
For all p1, p2 ∈ polyExpr, deg ( compose p1 p2 ) <=> (deg p1) * (deg p2)
```
**TA COMMENT (zhan2361)**: For the property, you should not induct on both p1 and p2 , since the compose code is only recursive in the first argument
      P(p1) : \forall p2, deg (compose p1 p2) = (deg p1)*(deg p2) -0.5
#### Base Case:
```
There are 2 base cases, which are when p1 = X and when p1 = Int x 
Proof: 
When p1 = X, we want to show for all p2 ∈ polyExpr, deg ( compose X p2 ) <=> (deg X) * (deg p2)
deg ( compose X p2 ) <=> deg p2    [ by subsitution ]
                     <=> 1 * deg p2    [ by property of identity in multiplication ]
                     <=> ( deg X ) * ( deg p2 )    [ by definition of deg function ]
So the base case for p1 = X proved.                      
When p1 = Int x, we want to show for all p2 ∈ polyExpr, deg ( compose (Int x) p2 ) <=> (deg (Int x)) * (deg p2)
deg ( compose (Int x) p2 ) <=> deg (Int x)    [ by subsitution ]
                           <=> 0    [ by evaluation ]
                           <=> 0 * ( deg p2 )    [ by property of multiply by zero ]
                           <=> ( deg (Int x) ) * ( deg p2 )    [ by definition of function deg ]
So the base case for p1 = Int x proved.
So base case proved. 
```
#### Inductive Case:
```
We want to show that For all p1, p2 ∈ polyExpr, for all x,y ∈ polyExpr,
when p1 = Add (x,y), deg ( compose x p2 ) <=> (deg x) * (deg p2), deg ( compose y p2 ) <=> (deg y) * (deg p2) ==>
deg ( compose (Add (x,y)) p2 ) <=> ( deg (Add (x,y))) * ( deg p2 )

We want to show that For all p1, p2 ∈ polyExpr, for all x,y ∈ polyExpr,
when p1 = Mul (x,y), deg ( compose x p2 ) <=> (deg x) * (deg p2), deg ( compose y p2 ) <=> (deg y) * (deg p2) ==>
deg ( compose (Mul (x,y)) p2 ) <=> ( deg (Mul (x,y))) * (deg p2)
```
##### Inductive Hypothesis:
```
For all p1, p2 ∈ polyExpr, for all x,y ∈ polyExpr,
when p1 = Add (x,y), deg ( compose x p2 ) <=> (deg x) * (deg p2), deg ( compose y p2 ) <=> (deg y) * (deg p2)
when p1 = Mul (x,y), deg ( compose x p2 ) <=> (deg x) * (deg p2), deg ( compose y p2 ) <=> (deg y) * (deg p2) 
```
##### Inductive Case Proof:
```
For all p1, p2 ∈ polyExpr, for all x,y ∈ polyExpr,
when p1 = Add (x,y),
   deg ( compose (Add (x,y)) p2 ) <=> deg ( Add (compose x p2, compose y p2) )    [ by subsitution ]
                                  <=> max ( deg (compose x p2) ) ( deg (compose y p2) )    [ by evaluation ]
                                  <=> max ( (deg x) * (deg p2) ) ( (deg y) * (deg p2) )    [ by inductive hypothesis ]
                                  <=> ( max ( deg x ) ( deg y ) ) * ( deg p2 )    [ by the property of integer multiplication  and property of max]
                                  <=> (deg (Add (x, y)) * (deg p2)    [ by definition of function deg ]
So when p1 = Add (x,y), inductive case proved.
when p1 = Mul (x,y),
   deg ( compose (Mul (x,y)) p2 ) <=> deg ( Mul (compose x p2, compose y p2) )    [ by subsitution ]
                                  <=> (deg (compose x p2)) + (deg (compose y p2))    [ by evaluation ]
                                  <=> (deg x) * (deg p2) + (deg y) * (deg p2)   [ by inductive hypothesis ]
                                  <=> ( (deg x) + (deg y) ) * (deg p2)    [ by the property of integer multiplication distributive law ]
                                  <=> (deg (Mul (x, y)) * (deg p2)    [ by definition of function deg ]
So when p1 = Mul (x,y), inductive case proved.

  So, inductive case proved. 
  So, For all p1, p2 ∈ polyExpr, deg ( compose p1 p2 ) <=> (deg p1) * (deg p2)

**TA COMMENT (zhan2361)**: 9.5/10
```

#Poly Proof 3
I need to prove the following property P(p):
```
For all p ∈ polyExpr, deg ( simplify p ) <= deg p
```

#### Base Case:
```
There are 2 base cases, which are when p = X and when p = Int x 
Proof: 
When p = X, we want to show for all p ∈ polyExpr, deg ( simplify X ) <= deg X
deg ( simplify X ) <=> deg X <= deg X    [ by subsitution ]
So the base case for p = X proved.                      

When p = Int x, we want to show for all p ∈ polyExpr, deg ( simplify ( Int x ) ) <= deg ( Int x )
deg ( simplify (Int x) ) <=> deg (Int x) <= deg (Int x)    [ by subsitution ]
So the base case for p = Int x proved.

So base case proved. 
```
#### Inductive Case:
```
We want to show that for all p ∈ polyExpr, for all x,y ∈ polyExpr,
when p = Add (x,y), deg ( simplify x ) <= deg x, deg ( simplify y ) <= deg y ==>
deg ( simplify (Add (x,y)) ) <= deg (Add (x,y))

We want to show that for all p ∈ polyExpr, for all x,y ∈ polyExpr,
when p = Mul (x,y), deg ( simplify x ) <= deg x, deg ( simplify y ) <= deg y ==>
deg ( simplify (Mul (x,y))) <= deg (Mul (x,y)) 
```
##### Inductive Hypothesis:
```
For all p ∈ polyExpr, for all x,y ∈ polyExpr,
when p = Add (x,y), deg ( simplify x ) <= deg x, deg ( simplify y ) <= deg y
when p = Mul (x,y), deg ( simplify x ) <= deg x, deg ( simplify y ) <= deg y
```
##### Inductive Case Proof:
```
For all p ∈ polyExpr, for all x,y ∈ polyExpr,
when p = Add (x,y),
   deg ( simplify (Add (x,y)) ) <=> deg ( simp_add ( simplify x, simplify y ) )    [ by subsitution ]
There are three situations, first is when one of x or y is Int 0, 
         when x is Int 0,
                                <=> deg y    [ by subsitution ]
         when y is Int 0, 
                                <=> deg x    [ by subsitution ]
  Since,
   deg ( Add (x,y) ) <=> max ( deg x ) ( deg y )    [ by subsitution ]
  So 
   deg y <= max ( deg x ) ( deg y )    [ by property of <= and property of max ]
   deg x <= max ( deg x ) ( deg y )    [ by property of <= and property of max ]
  So
   deg ( simplify (Add (x,y))) <= deg ( Add (x,y)), when one of x or y is Int 0 is proved. 
   
The second situation is when both x and y are Int x, x = Int i1, y = Int i2
    deg ( simplify (Add (x,y))) <=> deg ( Int (i1+i2)  )    [ by subsitution ]
                                <=> 0    [ by evaluation ]
    deg ( Add (x,y) ) <=> max (deg x) (deg y)    [ by subsitution ]
                      <=> max 0 0    [ by evaluation ]
                      <=> 0    [ by the property of max ]
    deg ( simplify (Add (x,y))) <=> deg ( Add (x,y) ) 
                                <= deg ( Add (x,y) )    [ by property of <= ]
   So
    deg ( simplify (Add (x,y))) <= deg ( Add (x,y)), when both of x and y are Int x is proved.
    
The third situation is when both x and y are either not X or Int x, 
    deg ( simplify (Add (x,y))) <=> deg ( Add (x,y) )    [ by subsitution ]
                                <= deg ( Add (x,y) )    [ by property of <= ]
   So
    deg ( simplify (Add (x,y))) <= deg ( Add (x,y)), when both of x and y are not Int x or X is proved.

So all three cases are proved. deg ( simplify (Add (x,y))) <= deg ( Add (x,y)) proved.


For all p ∈ polyExpr, for all x,y ∈ polyExpr,
when p = Mul (x,y),
   deg ( simplify (Mul (x,y)) ) <=> deg ( simp_mul ( simplify x, simplify y ) )    [ by subsitution ]
There are three situations, first is when one of x or y is Int 0, 
         when x is Int 0,
                                <=> deg (Int 0)    [ by subsitution ]
                                <=> 0    [ by evaluation ]
         when y is Int 0, 
                                <=> deg (Int 0)    [ by subsitution ]
                                <=> 0    [ by evaluation ]
  Since, 
   deg ( Mul (x,y) ) <=> ( deg x ) + ( deg y )    [ by subsitution ]
  And 
   deg x <=> 0 <= ( deg x ) + ( deg y )    [ by property of <= and property of max ]
   deg y <=> 0 <= ( deg x ) + ( deg y )    [ by property of <= and property of max ]
  So
   deg ( simplify (Mul (x,y))) <= deg ( Mul (x,y)), when one of x or y is Int 0 is proved. 
   
The second situation is when x and y are Int 1,
  when x = Int 1,
    deg ( simplify (Mul (x,y))) <=> deg y     [ by subsitution ]
  when y = Int 1,
    deg ( simplify (Mul (x,y))) <=> deg x    [ by subsitution ]

    deg ( Mul (x,y) ) <=> (deg x) + (deg y)    [ by subsitution ]
  
  Since deg x <= (deg x) + (deg y)    [ by the property of <= ]
        deg y <= (deg x) + (deg y)    [ by the property of <= ]
  So，
   deg ( simplify (Mul (x,y))) <= deg ( Mul (x,y)), when one of x or y is Int 1 is proved.

The third situation is when both x and y are Int x, x = Int i1, y = Int i2
    
    deg ( simplify (Mul (x,y))) <=> deg ( Int (i1*i2) )    [ by subsitution ]
                                <=> 0    [ by evaluation ]
    deg ( Mul (x,y) ) <=> (deg x) + (deg y)    [ by subsitution ]
                      <=> 0 + 0    [ by evaluation ]
                      <=> 0    [ by the property of integer adding ]
                      
   So
    deg ( simplify (Mul (x,y))) <=> deg ( Mul (x,y) ) 
                                <= deg ( Mul (x,y) )  
    So when both of x and y are Int x is proved.
    
The forth situation is when both x and y are not Int x or X, 
    deg ( simplify (Mul (x,y))) <=> deg ( Mul (x,y) )    [ by subsitution ]
                                <= deg ( Mul (x,y) )    [ by property of <= ]
   So
    deg ( simplify (Mul (x,y))) <= deg ( Mul (x,y)), when both of x and y are not Int x or X is proved.

So all four cases are proved. deg ( simplify (Mul (x,y))) <= deg ( Mul (x,y)) proved.
  
  
  So, inductive case proved. 
  So, for all p ∈ polyExpr, deg ( simplify p ) <= deg p.
```
**TA COMMENT (leid0065)**: Score: 10/10.
