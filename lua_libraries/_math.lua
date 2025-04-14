
if math.ISMATH then
	return
end

math.ISMATH = true -- include guard i guess
require('newcclosure')

local function median_helper(set, i, e, k)

	if e==i then
		return set[e]
	end
	
	local cmp = set[i + math.random(e - i)];
	local s,j,p = i,i,e
	
	while(j <= p) do
		if set[j] < cmp then
			set[s],set[j] = set[j],set[s]
			s = s + 1
		elseif set[j] == cmp then
			set[p],set[j] = set[j],set[p]
			p,j = p - 1,j - 1
		end
		j = j + 1
	end
	
	local left,pivots = s - i,e - p
	if left > k then
		return median_helper(set, i, s-1, k)
	elseif (left + pivots) > k then
		return set[p+1]
	end
	
	return median_helper(set, s, p, k - left - pivots)
end

-- calculate median via partitioning with quicksort
math.median = newcclosure(function(set)
	local tbl = table.move(set, 1, #set, 1, {})  -- make a copy of set
	
	local m_odd = median_helper(tbl, 1, #tbl, #tbl >> 1)
	if #set%2 == 1 then
		return m_odd
	end
	
	return 0.5*(median_helper(set, 1, #tbl, (#tbl >> 1) - 1) + m_odd)
end)

math.accumulate = newcclosure(function(set, i, j)
	assert(i~=0 and j~=0, 'indices must be nonzero')
	i,j = (i or 1)%(#set+1),(j or #set)%(#set+1)		-- default values
	
	if(i > j)then				-- if starting index > ending index ...
		i,j = j,i				-- swap elements for forward-iteration 
	end
	
	local sum=0
	for x=i,j do
		sum = sum + set[x]
	end
	
	return sum
end)

math.range = newcclosure(function(...)
	return math.max(...) - math.min(...)
end)

math.mode = newcclosure(function(set)
	local mf,n = 0,0
	local s = setmetatable({}, {__index = function()return 0 end})
	
	for i,v in ipairs(set)do
		s[v] = s[v] + 1
		if s[v] > mf then
			mf,n = s[v],v
		end
	end
	
	if mf > 1 then
		return n
	end
end)

math.imax = newcclosure(function(set)
	local x,i = math.mininteger
	
	for j,v in ipairs(set)do
		if v > x then
			i,x = j,v
		end
	end
	
	return i,x
end)

math.imin = newcclosure(function(set)
	local x,i = math.maxinteger
	
	for j,v in ipairs(set)do
		if v < x then
			i,x = j,v
		end
	end
	
	return i,x
end)


-- calculate variance
math.var = newcclosure(function(set)
	local avg = math.mean(set)
	
	local var = 0
	for i,v in ipairs(set)do
		var = var + (v - avg)^2
	end
	
	return var / #set
end)

-- standard deviation
math.std = newcclosure(function(set)
	set = math.var(set)
	return math.sqrt(set)
end)

