Some lua libraries..

newcclosure(function): simply creates a c-closure of the input function

_math: adds some useful math functions to the lua math library:

  these functions can easily be updated to operate over a range of elements inside the 
  argument array, but the majority of cases are not necessary for that operation
   - math.median({} : table) (calculates median of a numbered-array)
   - math.mean({} : table)   (calculates mean of a numbered-array)
   - math.mode({} : table)   (calculates the mathematical mode of a numbered-array)
   - math.accumulate({} : table, i : int, j : int)  (calculates the sum of of numbers within the range (i,j), numbers can be negative to indicate starting from the back of the table)
   - math.range(...)   (calculates the range of the tuple)
   - math.imax({} : table)  (calculates the index of the max element in the table, also returns the max element)
   - math.imin({} : table)  (calculates the index of the min element in the table, also returns the min element)
   - math.var({} : table)   (calculates the variance of the set)
   - math.std({} : table)   (calculates the standard deviation of the set)
