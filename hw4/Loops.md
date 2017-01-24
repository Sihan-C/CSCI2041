##Problem 1
The state is (i,fi)

##Problem 2
```
let flsearch (f: int->int) (n:int) = {
  let (i,fi) = (0, ( f 0 )) in
  let rec wloop (i, fi) = if ( i <= n && f i <= 0 ) then wloop (i+1, f (i+1)) else (i,fi) in  
  let (i1,fi1) = wloop (i,fi) in
  i1
}


```
##Problem 3
###Lemma: 
For all n,i ∈ N, if ( i', fi') = wloop (i, fi) then (f i') > 0 and f a > 0 for ( i' <= a ∈ N <= n ), 
##### Base Case
```
This is a trivial proof, based on the condition of the if statement
 wloop (i, fi) <=> if ( i <= n && f i <= 0 ) then wloop (i+1, f (i+1)) else (i,fi) 
 only when f i > 0 or i > n, it will go to the else branch, which is return the value of (i', fi').
 Based on the precondition, 
        Precondition: (f (i+1)) >= (f i) for all i < n, f(0) < 0 and f(n) > 0
 There will be 2 cases, one is when f i for i < n are all less than 0, when i = n, then 
 it will go to the else branch since f i > 0, the second condition violate. And since f n > 0 ( based on the precondition),
 i' = n, f i' > 0 and f a > 0 for ( i' <= n ∈ N <= n ) is also proved since a = n. So the base case when i' = n proved.
 The other case is when a f i'' for i'' < n larger than 0 occurred. then it will go to the else branch, since f i'' > 0,
 the second condition violate. And since f i'' > 0, i' = i'', f i' > 0. And based on the precondition, (f (i+1)) >= (f i) for all i < n. f a > 0 for ( i' < a ∈ N <= n ) also proved. 
 
 So base case proved. 
 
```
##### Inductive Case
```
For all n,i ∈ N, if ( i', fi') = wloop (i, f i) then (f i') > 0 and f a > 0 for ( i' < a ∈ N <= n )
For all n,i ∈ N, if ( i'+1, fi') = wloop (i+1, f (i+1)) then (f (i'+1)) > 0 and f a > 0 for ( i'+1 <= a ∈ N <= n )

```
##### Inductive Hypothesis:
```
For all n,i ∈ N, if ( i', fi') = wloop (i, f i) then (f i') > 0 and f a > 0 for ( i' < a ∈ N <= n )
```
##### Inductive Case Proof:
```
if ( i'+1, fi') = wloop (i+1, f (i+1)), then i'+1 > 0, based on the inductive hypothesis i' > 0 and the monotonically increasing property of the function f. And Because of the monotonically increasing property of the function f, 
f a > 0 for ( i'+1 <= a ∈ N <= n ). 
So inductive case proved. 
For all n,i ∈ N, if ( i', fi') = wloop (i, fi) then (f i') > 0 and f a > 0 for ( i' <= a ∈ N <= n )
proved.
```

## Prove 1
I need to prove the following property P(n):
```
For all f, for all n ∈ N, if (f n) > 0 then f (flsearch f n) > 0
```

#### Base Case:
```
If (f n) > 0, then f ( flsearch f n ) <=> f i'    [ by evaluation ] 
                                      <=> f i' > 0    [ by lemma ]
                                      > 0
So base case proved. 
```
#### Inductive Case:
```
For all f, for all n ∈ N, if (f n) > 0 then f (flsearch f n) > 0
==> For all f, for all n ∈ N, if (f (n+1)) > 0 then f (flsearch f n+1) > 0
```
#### Inductive Hypothesis:
```
For all f, for all n ∈ N, if (f n) > 0 then f (flsearch f n) > 0
```
#### Inductive Case Proof:
```
if f (n+1) > 0, 
f (flsearch f n+1) <=> i'    [ by evaluation and lemma ]
                   <=> f (flsearch f n)   [ by lemma ]
                   > 0    [ by inductive hypothesis ]
So inductive case proved. 
So for all f, for all n ∈ N, if (f n) > 0 then f (flsearch f n) > 0
Since flsearch is the ocaml implementation of flsearch, 
For all f, for all n ∈ N, if (f n) > 0 then f (lsearch f n) > 0 is informally proved. 
```
## Prove 2
I need to prove the following property P(n):
```
For all f, if (f 0) < 0 then for all n, i < (flsearch f n) => (f i) < 0
```

#### Base Case:
```
If (f 0) < 0, and for all n, i < (flsearch f n)
flsearch f 0 <=> 1    [  by evaluation ]
Since i < (flsearch f n) <=> 1 ==> i = 0.
And since f 0 < 0
f i < 0
So base case proved. 
```
#### Inductive Case:
```
For all f, if (f 0) < 0 then for all n, i < (flsearch f n) => (f i) < 0
==> For all f, if (f 0) < 0 then for all n, i < (flsearch f (n+1)) => (f i) < 0
```
#### Inductive Hypothesis:
```
For all f, if (f 0) < 0 then for all n, i < (flsearch f n) => (f i) < 0
```
#### Inductive Case Proof:
```
if (f 0) < 0, and i < (flsearch f (n+1))
(flsearch f (n+1)) <=> i'    [ by lemma and evaluation ]
                  <=> (flsearch f n)    [ by lemma ]
So i < (flsearch f n)
   f i < 0     [ by inductive hypothesis ]
So inductive case proved.    
Since flsearch is the ocaml implementation of flsearch, 
For all f, if (f 0) < 0 then for all n, i < (lfsearch f n) => (f i) < 0 is informally proved.
```
