Some lua libraries..

newcclosure(function): simply creates a c-closure of the input function

_math: adds some useful math functions to the lua math library:

  these functions can easily be updated to operate over a range of elements inside the 
  argument array, but the majority of cases are not necessary for that operation
   - math.median({} : table) (calculates median of a numbered-array)
   - math.mean({} : table)   (calculates mean of a numbered-array)
   - math.mode({} : table)   (calculates the mathematical mode of a numbered-array)
   - math.imax({} : table)  (calculates the index of the max element in the table, also returns the max element)
   - math.imin({} : table)  (calculates the index of the min element in the table, also returns the min element)
   - math.var({} : table)   (calculates the variance of the set)
   - math.std({} : table)   (calculates the standard deviation of the set)



numeric: adds c++ numerical methods functions, std::numeric
  
  all indices (i,j,k) can be negative to indicate starting-n from the end of a table:
    (indices are per example of logic in the functions) t : {1,2,3,4,5}, t[-2 ->] = {4,5},  t[-3,-2] = {3,4}

   - numeric.accumulate({} : table, i : int, j : int)  (calculates the sum of of numbers within the range (i,j), numbers can be negative to indicate starting from the back of the table)
   - numeric.adjacent_difference({} : table, i : int, j : int, k : int, {} : table)  (computes adjacent difference of elements in the first table within the range of indices i->j (default: 1, #first_table) and stores them in the second table starting from index k)
   - numeric.inner_product({} : table, i : int, j : int, k : int, {} : table)  (computes the cumulative inner product of the elements in the first table between the range of i->j (defaults: 1,#first_table) with the elements in the second table from the index k)
   - numeric.partial_sum(({} : table, i : int, j : int, k : int, {} : table)  (computes the partial sum of the first table between the range of i->j (defaults: 1,#first_table) and stores the result in the second table from starting index k)
   - numeric.iota(({} : table, i : int, j : int, init : int)  (stores an increasing sequence from the starting value, init, between the range of incides i->j (defaults: 1,#first_table) in the first table)
