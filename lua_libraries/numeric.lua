
-- https://cplusplus.com/reference/numeric/
-- could perhaps include binary operation overloading

if(numeric)then
	return
end

require'newcclosure'

local numeric = {}

-- helper function
local function fix_indices(set, i,j,k, out)
	i,j = (i or 1)%(#set + 1),(j or #set)%(#set + 1)		-- default values
	assert(j > 0, 'ending index must be nonzero')
	
	if(i == 0)then
		i = 1
	end
	
	if(i > j)then				-- if starting index > ending index ...
		i,j = j,i				-- swap elements for forward-iteration 
	end
	
	if(k)then
		out = out or {}
		k = (k or 1)%(#out + 1)
		if(k == 0)then
			k = 1
		end
	end
	
	return i,j,k,out
end

--	accumulate values in range
numeric.accumulate = newcclosure(function(set, i, j, init)
	i,j = fix_indices(set,i,j)
	init = init or 0
	
	local sum = 0
	for x=i,j do
		sum = sum + set[x]
	end
	
	return sum
end)

--	Compute adjacent difference of range
numeric.adjacent_difference = newcclosure(function(set, i, j, k, out)
	i,j,k,out = fix_indices(set,i,j,k,out)
	
	if(not set[i-1])then
		out[k],i,k = set[i],i+1,k+1
	end
	
	for x=i,j do
		out[k],k = set[x]-set[x-1],k+1
	end
	return out
end)


--	Compute cumulative inner product of range
numeric.inner_product = newcclosure(function(set, i, j, k, out, init)
	i,j,k,out = fix_indices(set,i,j,k,out)
	init = init or 0
	
	assert((j - i) <= (#out - k), 'index range of input set greater than range of elements in output set')

	for x=i,j do
		init,k = init + set[x]*out[k],k+1
	end
	return init
end)


--	Compute partial sums of range (function template)
numeric.partial_sum = newcclosure(function(set, i, j, k, out)
	i,j,k,out = fix_indices(set,i,j,k,out)
	
	if(not set[i-1])then
		out[k],i,k = set[i],i+1,k+1
	end
	
	for x=i,j do
		out[k],k = set[x]+set[x-1],k+1
	end
	return out
end)

--	Store increasing sequence from starting value
numeric.iota = newcclosure(function(set, i, j, begin)
	i,j = fix_indices(set,i,j)
	
	for x=i,j do
		set[x],begin = begin,begin+1
	end
end)

_ENV.numeric = numeric
