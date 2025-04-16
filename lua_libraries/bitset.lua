
-- https://cplusplus.com/reference/bitset/

require'newcclosure'

local bitset = {}

local set = newcclosure(function(self,keysize)
	return function(idx,val)
		local key = idx//keysize + 1
		local tmp = self[key] or 0
		self[key],val = tmp,val&1					-- assign element at new arbitrary index if nil
		self[key] = tmp&~(1  << (idx%keysize))		-- reset bit
		self[key] = tmp|(val << (idx%keysize))		-- set bit
	end
end)

local reset = newcclosure(function(self,keysize)
	return function(idx)
		self[idx//keysize + 1] = self[idx//keysize + 1]&~(1 << (idx%keysize))
	end
end)

local flip = newcclosure(function(self,keysize)
	return function(idx)
		self[idx//keysize + 1] = self[idx//keysize + 1]^(1 << (idx%keysize))
	end
end)

local test = newcclosure(function(self,keysize)
	return function(idx)
		return (self[idx//keysize + 1]&(1 << (idx%keysize))) > 0
	end
end)

local any = newcclosure(function(self,keysize)
	return function()
		for i,v in next,self do
			if v > 0 then
				return true
			end
		end
		return false
	end
end)

local all = newcclosure(function(self,keysize)
	return function()
		for i,v in next,self do
			if v ~= ~0 then
				return false
			end
		end
		return true
	end
end)

local none = newcclosure(function(self,keysize)
	return function()
		for i,v in next,self do
			if v ~= 0 then
				return false
			end
		end
		return true
	end
end)

local size = newcclosure(function(self,keysize)
	return function()
		local k = 0
		for i,v in next,self do
			k = k + 1
		end
		return k*keysize
	end
end)

local count = newcclosure(function(self,keysize)
	return function()
		local k = 0
		for i,v in next,self do
			while v ~= 0 do
				k,v = k+(v&1),v>>1
			end
		end
		return k
	end
end)


local function bin(num,keysize)
	local s = ''
	while num > 0 do
		s,num = (num&1) .. s ,num >> 1
	end
	
	return string.rep('0', (keysize or #s) - #s) .. s
end

local tostring = newcclosure(function(self,keysize)
	return function()
		local k = nil
		for i,v in next,self do k=i end
		
		local s = bin(self[1] or 0, keysize)
		for i=2,k do
			s = bin(self[i] or 0, keysize) .. s
		end
		
		return string.match(s, '^0*(.+)')	-- remove leading 0's
	end
end)

local function _init(keys,keysize)
	return setmetatable({
		
		-- bit access
		count = count(keys,keysize),
		size  = size(keys,keysize),
		test  = test(keys,keysize),
		none  = none(keys,keysize),
		any   = any(keys,keysize),
		all   = all(keys,keysize),
		
		-- bit operations
		reset = reset(keys,keysize),
		flip = flip(keys,keysize),
		set  = set(keys,keysize),
		
		-- bitset operations
		tostring = tostring(keys,keysize) 
	},{
		__index = function(self,key)
			if(type(key)=='number')then
				if(keys[key//keysize + 1])then
					return self.test(key)
				end
				return false
			end
		end,
		__newindex = function(self,key,val)
			if(type(key)=='number'and type(val)=='number')then
				self.set(key, val)
			end
		end
	})
end

_ENV.bitset = setmetatable({}, {
	__call = function()
		local n,i = 1,0			-- determine the wordsize of your pc
		while(n~=0)do
			n,i = n<<1,i+1
		end
	
		return _init({},i)
	end
})
