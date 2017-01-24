First, I need to prove two lemmas.
######lemma 1 : For all l, l2 ∈ int list, tail_rev l l2 <=> l^R @ l2, where l^R is the reverse of the list l.
```
The base case is length P([]): tail_rev [] l2 <=> []^R @ l2
tail_rev [] l2 <=>  match [] with    [ by subsitution ]
                    | [] -> acc
                    | h::t -> tail_rev t (h::acc)
               <=> l2    [ by evaluation of function reverse ]
               <=> [] @ l2    [ by the property of empty list ]
     Since []^R = [] 
               <=> []^R @ l2    [ by the property of empty list ]
So base case proved. 

For the inductive case, we want to prove, for all l ∈ int list, for all x ∈ int, P(l) ==> P(x::l)
tail_rev l l2 <=> l^R @ l2 ==> tail_rev (x::l) l2 <=> (x::l)^R @ l2
Inductive hypothesis is for all l ∈ int list, for all x ∈ int, tail_rev l l2 <=> l^R @ l2
Poof of inductive case:
     tail_rev (x::l) l2 <=> tail_rev l (x::l2)    [ by evaluation of function tail_rev ]
                        <=> l^R @ (x::l2)    [ by inductive hypothesis ]
                        <=> l^R @ [x] @ l2    [ by the property of list ]
                        <=> (x::l)^R @ l2    [ by the property of list ]
So the inductive case proved. 
So lemma: For all l, l2 ∈ int list, tail_rev l l2 <=> l^R @ l2, where l^R is the reverse of the list l. proved. 

```
######lemma 2 : For all l, l2 ∈ int list, length ( l @ l2 ) <=> length( l )+ length( l2 )
```
The base case is length P([]): length ( [] @ l2 ) <=> length [] + length l2  
Since 
length ( [] @ l2 ) <=> length l2    [ by list property ] 
So base case proved. 

For the inductive case, we want to prove, for all l ∈ int list, P(l) ==> P(x::l)
length ( l @ l2 ) <=> length l + length l2 ==> length ( (x::l) @ l2 ) <=> length (x::l) + length l2
Inductive hypothesis is for all l ∈ int list, length ( l @ l2 ) <=> length l + length l2
Poof of inductive case:
     length ( (x::l) @ l2 ) <=> length ( [x] @ l @ l2 )    [ by list property ]
                            <=> length ( l @ [x] @ l2 ) <=> length ( l @ (x::l2) )    [ by list property ]
                            <=> length l + length (x::l2)    [ by inductive hypothesis ] 
                            <=> length l + 1 + length l2    [ by subsitute into length function and evaluation ]
                            <=> length (x::l) + length l2    [ by the definition of function length ] 
So the inductive case proved. 
So lemma:  For all l, l2 ∈ int list, length ( l @ l2 ) <=> length( l )+ length( l2 ). proved. 

```
The correctness of function reverse is proved by the lemma 1.
```
By lemma 1 we know 
  reverse l <=> tail_rev l [] <=> l^R @ [] <=> l^R
  So reverse function will take in a list and return the reverse of that list. 
```
#List Proof 1

I need to prove the following property P(l):
```
For all l ∈ int list, length l <=> length ( reverse l ) 
```

#### Base Case:
```
For base case, we want to show: P([]) : length [] <=> length ( reverse [] ) 
Proof: 
     length [] <=> match [] with | [] -> 0 | _::t -> 1 + ( length t )   [ by substitution ]
               <=> 0    [ by evaluation of length function ]  
     length ( reverse [] ) <=> length ( let rec tail_rev lst acc = match lst with    [ by substitution ]
                                    | [] -> acc
                                    | h::t -> tail_rev t (h::acc)
                                    in tail_rev [] [] )           
                        <=> length []    [ by evaluation of reverse function ]
    Since length [] <=> length [] <=> 0                      
So base case proved.
```
#### Inductive Case:
```
We want to show that For all l ∈ int list, length l <=> length ( reverse l ) ==> For all l ∈ int list, for all x ∈ int, length (x::l) <=> length ( reverse (x::l) )
```
##### Inductive Hypothesis:
```
For all l ∈ int list, length l <=> length ( reverse l ) 
```
##### Inductive Case Proof:
```
For all x ∈ int,
length (x::l) <=> match (x::l) with | [] -> 0 | _::t -> 1 + (length t)    [ by substitution ]
              <=> 1 + length l    [ by evaluation of length function ] 
              <=> 1 + length ( reverse l )    [ by inductive hypothesis ]
              <=> length ( x::( reverse l ) )    [ by the definition of length function ]
              <=> length (x::l^R)    [ by the correctness of reverse function proved above ]
And 
By lemma 2, 
length (x::l^R) <=> length ([x]@ l^R) <=> length x + length (l^R) <=> length (l^R @ [x]) 

length (l^R @ [x]) <=> length ( (x::l)^R )    [ by list property ]
                   <=> length ( reverse (x::l) )    [ by the correctness of reverse function proved above ]

So, length (x::l) <=> length ( reverse (x::l) ), inductive case proved. 

So by the principle of List induction, For all l ∈ int list, length l = length ( reverse l )
```
######lemma 3 :
```
For all l ∈ int list, P(l): for all a ∈ int,  tsum l a <=> Sum of all the element in the list plus a.
In the following prove, sum of all the element in a list is represented by Sum(l).
```

#### Base Case:
```
For base case, we want to show: P([]) : tsum [] a <=> Sum( [] ) + a  
Proof: 
     tsum [] a <=> match [] with | [] -> a | h::t -> tsum t ( h + a )    [ by substitution ]
               <=> a    [ by evaluation of function tsum ]
               <=> 0 + a <=> Sum( [] ) + a    [ by the property of empty list ]
So base case proved.
```
#### Inductive Case:
```
We want to show that for all l ∈ int list, for all a ∈ int, tsum l a <=> Sum(l) + a => For all l ∈ int list, 
for all x ∈ int, for all a ∈ int,  tsum (x::l) a  <=> Sum(x::l) + a
```
##### Inductive Hypothesis:
```
For all l ∈ int list, for all a ∈ int, tsum l a <=> Sum(l) + a  
```
##### Inductive Case Proof:
```
For all x ∈ int,
tsum (x::l) a <=> match (x::l) with | [] -> a | h::t -> tsum t ( h + a )    [ by substitution ]
              <=> tsum l ( x + a )    [ by evaluation of function tsum ]
              <=> Sum(l) + a + x    [ by inductive hypothesis ]
              <=> Sum(x::l) + a    [ by the property of adding integer number ]  
  So inductive case proved.            

So for all l ∈ int list, P(l): for all a ∈ int,  tsum l a <=> Sum(l) + a <=> Sum of all the element in the list plus a.
```
And the correctness of the tail_sum function can be easily proved by using lemma 3
```
By lemma 3,
tail_sum l <=> tsum l 0 <=> Sum(l) + 0 <=> Sum(l) <=> Sum of all the integer number in the list l
```

#List Proof 2

I need to prove the following property P(l):
```
For all l ∈ int list, tail_sum l <=> tail_sum ( reverse l )
```
We first prove tsum l a <=> tsum ( reverse l ) a
#### Base Case:
```
For base case, we want to show: P([]) : tsum [] a <=> tsum ( reverse [] ) a 
Proof: 
     tsum [] a <=> a  [ by substitution into tail_sum function and evaluation of tail_sum function ]
     tsum ( reverse [] ) a <=> tsum [] a    [ by the property of empty set ]
     So, tsum [] a <=> tsum ( reverse [] ) a <=> 0                      
So base case proved.
```
#### Inductive Case:
```
We want to show that For all l ∈ int list, for a ∈ int, tsum l a<=> tsum ( reverse l ) a ==>
For all l ∈ int list, for all x ∈ int, tsum (x::l) a <=> tsum ( reverse (x::l) ) a
```
##### Inductive Hypothesis:
```
For all l ∈ int list, tsum l a <=> tsum ( reverse l ) a 
```
##### Inductive Case Proof:
```
For all x ∈ int,
tsum (x::l) a <=> tsum l ( x + a )    [ by substitution ]
              <=> tsum ( reverse l ) ( x + a )    [ by inductive hypothesis ]
              <=> Sum( reverse l ) + x + a    [ by lemma 3 ]
      And since Sum( l ) is adding up all the integers in the list l. So 
      for a ∈ int, Sum(l) + a = Sum( l @ [a] )  
              <=> Sum( ( reverse l ) @ [x] ) + a    [ by property of adding integer ]
              <=> tsum ( ( reverse l ) @ [x] ) a    [ by lemma 3 ]
              <=> tsum ( (l^R) @ [x] ) a    [ by the correctness of function reverse proved before ]
              <=> tsum ( (x::l)^R ) a    [ by property of list ]
              <=> tsum ( reverse (x::l) ) a    [ by the correctness of function reverse proved before ]
              
So inductive case proved. 

So, for all l ∈ int list, a ∈ int, tsum l a <=> tsum ( reverse l ) a proved. 
Since tail_sum l <=> tsum l 0 and tail_sum ( reverse l ) <=> tsum ( reverse l ) 0
Since tsum l 0 <=> tsum ( reverse l ) 0
So tail_sum l <=> tail_sum ( reverse l ) proved. 

```


