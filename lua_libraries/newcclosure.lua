
-- exe guard
if(newcclosure)then
	return
end

-- does not support recursion
_ENV.newcclosure = coroutine.wrap(function(f)
	while(true)do
		while(debug.getinfo(f).what == 'C')do
			f = coroutine.yield(f)
		end
		local c = f
		f = coroutine.yield(coroutine.wrap(function(...)
			local args = {...}
			while(true)do
				args = {coroutine.yield(c(table.unpack(args)))}
			end
		end))
	end
end)

-- recursion example:

-- local function clone(tbl)
	-- assert(type(tbl) == "table", IDX_ERR:format("table", 1, type(tbl) or "nil"))
	-- local x = {}
	-- for idx,val in next,tbl do
		-- if(type(val) == "table")then
			-- x[idx] = clone(val)
		-- else
			-- x[idx] = val
		-- end
	-- end
	-- return x
-- end

-- table.clone = newcclosure(clone)
