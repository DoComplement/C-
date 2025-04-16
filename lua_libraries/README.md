Some lua libraries..

newcclosure(function): simply creates a c-closure of the input function

## _math: adds some useful math functions to the lua math library:

  these functions can easily be updated to operate over a range of elements inside the 
  argument array, but the majority of cases are not necessary for that operation
   - math.median({} : table) (calculates median of a numbered-array)
   - math.mean({} : table)   (calculates mean of a numbered-array)
   - math.mode({} : table)   (calculates the mathematical mode of a numbered-array)
   - math.imax({} : table)  (calculates the index of the max element in the table, also returns the max element)
   - math.imin({} : table)  (calculates the index of the min element in the table, also returns the min element)
   - math.var({} : table)   (calculates the variance of the set)
   - math.std({} : table)   (calculates the standard deviation of the set)



## numeric: adds c++ numerical methods functions, std::numeric
  
  all indices (i,j,k) can be negative to indicate starting-n from the end of a table:
    (indices are per example of logic in the functions) t : {1,2,3,4,5}, t[-2 ->] = {4,5},  t[-3,-2] = {3,4}

   - numeric.accumulate({} : table, i : int, j : int)  (calculates the sum of of numbers within the range (i,j), numbers can be negative to indicate starting from the back of the table)
   - numeric.adjacent_difference({} : table, i : int, j : int, k : int, {} : table)  (computes adjacent difference of elements in the first table within the range of indices i->j (default: 1, #first_table) and stores them in the second table starting from index k)
   - numeric.inner_product({} : table, i : int, j : int, k : int, {} : table)  (computes the cumulative inner product of the elements in the first table between the range of i->j (defaults: 1,#first_table) with the elements in the second table from the index k)
   - numeric.partial_sum(({} : table, i : int, j : int, k : int, {} : table)  (computes the partial sum of the first table between the range of i->j (defaults: 1,#first_table) and stores the result in the second table from starting index k)
   - numeric.iota(({} : table, i : int, j : int, init : int)  (stores an increasing sequence from the starting value, init, between the range of incides i->j (defaults: 1,#first_table) in the first table)

## bitset: adds the bitset class with functions and operations based on c++ std::bitset
  The class interacts directly with individual bits and can interact with any arbitrary index, but that comes with current drawbacks:
  - negative indices can be set, but do not currently contribute to the tostring function
  -  such that the size of the set based on total quantity of bits is not accurate currently
  -  bits are stored in a set of integers
        (assume a word size (system type, like x64-based or x32-based system) of k)
      -> if the first k-bits are set/reset, only one integer will be contained in the set
      -> if some value within the index range of k->2k an integer will at index 2 in the set will be interacted with according to the bit index in that integer
      -> the size of the set corresponds to k*(quantity of integers)

     example: assume a x64-based system with bitset b and no bits are set
     - b[1] = 1     (will create an integer in the 1st index of the set (1//64 + 1 = 1), and set the 1st bit to 1)
     - b[5] = 1     (will set the 5th bit in the integer at index 1 of the set to 1)
     - b[66]= 1     (will create an integer in the (66//64+1)= 2nd index of the set and set the (66%64)= 2nd bit to 1)
     - b[512]=1     (will create an integer in the (512//64+1)= 9th index of the set and set the (512%64)= 0th bit to 1 (int value of 1))
     - ... ( and so on )

`require'bitset'     
local b = bitset()
`
- b.set(idx : int, val : int)    (will set the idx-th bit to be val, val can be any number, but will only set the bit to be 1 or 0 depending on val&1 or val%2 (odd -> 1, even -> 0))
- nil <- **b.reset(idx : int)**       *(will reset (set to 0) the idx-th bit to be 0)*
- nil <- **b.flip(idx : int)**        *(will flip the value (1->0, 0->1) of the idx-th bit)*
- bool <- **b.test(idx : int)**        *(returns true/false depending if the bit is high/low (1/0))*
- bool <- **b.any()**        *(returns true if any bits are high in the bitset)*
- bool <- **b.all()**        *(return true if all bits in the bitset are high)*
- bool <- **b.none()**        *(returns true if none of the bits in the bitset are high)*
- int <- **b.count()**        *(returns the quantity of set (1) bits in the bitset)*
- int <- **b.size()**        *(returns the total quantitiy of bits in the bitset (#ints x word_size))*
- string <- **b.tostring()**    *(returns a string representing the binary form of the bitset)*
