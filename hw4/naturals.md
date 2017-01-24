# power 

I need to prove the following property P(n):
```
For all n ∈ N,  for all x ∈ float , power x n <=> x^n 
```

#### Base Case:
```
For base case, we want to show: P(0) = For all x ∈ float , power x 0 <=> x^0 = 1.0    [ by property of power function ] 
Proof: 
     power x 0 <=> if n = 0 then 1.0 else x *. (power x n-1) = 1.0 = x^0   [ by substitution ]
So base case proved.
```
#### Inductive Case:
```
We want to show that For all n ∈ N,  for all x ∈ float , power x n <=>  x^n;  ==> For all n ∈ N,  for all x ∈ float , power x (n+1) <=>  x^(n+1)
```
##### Inductive Hypothesis:
```
For all n ∈ N,  for all x ∈ float , power x n <=> x^n 
```
##### Inductive Case Proof:
```
power x n+1 <=> if (n+1) = 0 then 1.0 else x *. (power x n+1-1)   [ by substitution ] 
            <=> if (n+1) = 0 then 1.0 else x *. (power x n)   [ by simplification ]
Since n is natural number and n+1 will never equal to 0, so 
power x n+1 <=> x *. (power x n)    [ by simplication based on natural number property ]
            <=> x *. x^n    [ by Inductive Hypothesis ]
            <=> x^(n+1)    [ by the property of power calculation ]
So by the principle of natural induction, For all n ∈ N,  for all x ∈ float , power x n <=>  x^n
```


#pow_nat

I need to prove the following property P(n):
```
For all n ∈ nat,  for all x ∈ float , power x (to_int n) <=> pow_nat x n
```
#### Base Case:
```
For base case, we want to show: For all n ∈ nat, P(Zero): For all x ∈ float, power x (to_int Zero) = pow_nat x Zero
Proof:
      power x (to_int Zero) <=> power x (match Zero with | Zero -> 0| Succ n' -> 1 + (to_int n'))    [ by substitution ]
      power x (to_int Zero) <=> power x 0    [ by definition of to_int function ]
      power x (to_int Zero) <=> if 0 = 0 then 1.0 else x *. (power x n-1)    [ by substitution ]
      power x (to_int Zero) <=> 1.0    [ by definition of power function ]
   Also, for the pow_nat x Zero 
      pow_nat x Zero <=> match Zero with| Zero -> 1.0| Succ n' -> x *. (pow_nat x n')    [ by substitution ]
      pow_nat x Zero <=> 1.0    [ by definition of pow_nat function ]
   Since, 
      1.0 = 1.0 
   So, 
      power x (to_int Zero) = pow_nat x Zero
   Base case proved. 
```
#### Inductive Case:
```
For all n ∈ nat,  for all x ∈ float, power x (to_int n) <=> pow_nat x n  ==> For all n ∈ nat,  for all x ∈ float , power x (to_int (Succ n)) <=> pow_nat x (Succ n) 
```
##### Inductive Hypothesis:
```
For all n ∈ nat,  for all x ∈ float, power x (to_int n) <=> pow_nat x n 
```
##### Inductive Case Proof:
```
power x (to_int (Succ n)) <=> power x (match (Succ n) with | Zero -> 0 | Succ n' -> 1 + (to_int n'))    [ by substitution ]
power x (to_int (Succ n)) <=> power x ( 1 + ( to_int n ) )    [ by definition of to_int function ]
Since the definition of power function is:
     power x n <=> x^n
So,
     power x ( 1 + ( to_int n ) ) = x^(1 + ( to_int n ))    [ by definition of power function ]    
                                  = x * ( x^( to_int n ))    [ by principle of power calculation ]
                                  = x * power x ( to_int n )    [ by definition of power function ]
So, we can substitute the result above back into our proof.
power x (to_int (Succ n)) <=> x * power x ( to_int n )    [ by proof above ]
                          <=> x * pow_nat x n    [ by inductive hypothesis ]
                          <=> match (Succ n) with | Zero -> 1.0 | Succ n' -> x *. (pow_nat x n')    [ by substitution ]
                          <=> pow_nat x (Succ n)    [ by the definition of pow_nat function ]

So by the principle of induction for nat, For all n ∈ N,  For all n ∈ nat,  for all x ∈ float , power x (to_int n) <=> pow_nat x n
```

#less_nat

I need to prove the following property P(n):
```
For all m ∈ nat,  for all n ∈ nat, less_nat m n <=> (to_int m) < (to_int n).
```
#### Base Case:
```
For base case, we want to show:
For all n ∈ nat, P(Zero): For all m ∈ nat, less_nat m Zero <=> (to_int m) < (to_int Zero)
Proof:
     less_nat m Zero <=> match Zero with | Zero -> false               [ by substitution ]
                                      | Succ n' -> if m = n' then true 
                                                   else less_nat m n'  
                     <=> false    [ by definition of less_nat function ]
  Also, 
     to_int Zero <=> match n with | Zero -> 0 | Succ n' -> 1 + (to_int n')    [ by substitution ]
                 <=> 0    [ by definition of to_int function ]
     to_int m <=> There are two situations, one is m is Zero, the other one is m is not Zero. 
                  When m is Zero, like the proof above, to_int m is 0. And 0 < 0 is false. So when m is Zero,
                  less_nat m Zero <=> (to_int m) < (to_int Zero) proved. 
                  When m is not Zero, to_int m <=> 1 + ( 1 + ...(to_int n')), the number of 1s depend on how many Succ m                       have. And 1 + (1 + ...(to_int n')) will always larger than 0. So to_int m, when m is not Zero, will return
                  a value larger than 0. So (to_int m) < (to_int Zero) will evaluate to false. 
                  So, less_nat m Zero <=> (to_int m) < (to_int Zero) when m is not Zero also proofed.
  So, Base case proved. 
```
#### Inductive Case:
```
For all m ∈ nat,  for all n ∈ nat, less_nat m n <=> (to_int m) < (to_int n) ==> 
For all m ∈ nat,  for all n ∈ nat, less_nat m (Succ n) <=> (to_int m) < (to_int (Succ n))
```
##### Inductive Hypothesis:
```
For all m ∈ nat,  for all n ∈ nat, less_nat m n <=> (to_int m) < (to_int n)
```
##### Inductive Case Proof:
```
less_nat m (Succ n) <=> match (Succ n) with | Zero -> false               [ by substitution ]
                                            | Succ n' -> if m = n' then true 
                                                         else less_nat m n'
                    <=> if m = n then true else less_nat m n    [ by simplification ]
          There are two cases. One is when m = n, one is otherwise. 
          When m = n, less_nat m (Succ n) <=> true.
          when m != n, less_nat m (Succ n) <=> (to_int m) < (to_int n)    [ by inductive hypothesis ]
          So, now we only need to prove when m = n, (to_int m) < (to_int n) will evaluate to true.
          
To prove this, we need the definition of to_int, which is shown below:
let rec to_int n = match n with
                    | Zero -> 0
                    | Succ n' -> 1 + (to_int n')

When m = n, we want to show which one is larger, to_int ( Succ(n) ) or to_int ( n ) (which equals to to_int( m )).
In order to prove that, we need to prove a lemma, that is for all n ∈ nat, to_int n + 1 <=> to_int (Succ n) 
For the base case, when n is Zero, 
to_int Zero <=> match Zero with    [ by substitution ]
               | Zero -> 0
               | Succ n' -> 1 + (to_int n')
            <=> 0    [ by evaluation ]
to_int ( Succ Zero ) = match ( Succ Zero ) with    [ by substitution ]
               | Zero -> 0
               | Succ n' -> 1 + (to_int n')
            <=> 1 + to_int Zero    [ by evaluation ]             
            <=> 1 + 0    [ by proof shown above ]
            
Since 1 = 0 + 1, base case proved. 
For the inductive case 
Inductive hypothesis is for all n ∈ nat, to_int n + 1 = to_int (Succ n)
to_int ( Succ n ) + 1  <=> ( match Succ n with    [ by substitution ]
                                  | Zero -> 0
                                  | Succ n' -> 1 + (to_int n') ) + 1
                       <=> 1 + to_int n + 1    [ by evaluation ]
                       <=> to_int (Succ n) + 1    [ by inductive hypothesis ]
                       <=> to_int (Succ (Succ n))    [ by definition of function to_int ]
So inductive case proved. 
So to_int n + 1 <=> to_int (Succ n) proved. 

So back to the problem. Since to_int n + 1 <=> to_int (Succ n) 
                              to_int n < to_int (Succ n) 
                              to_int m < to_int (Succ n)
       to_int m < to_int (Succ n) ==> true <=> less_nat m (Succ n), so when m = n also proved. 

So inductive case of less_nat m n <=> (to_int m) < (to_int n) proved. 
So for all m ∈ nat,  for all n ∈ nat, less_nat m n <=> (to_int m) < (to_int n) proved.

```

 

  
