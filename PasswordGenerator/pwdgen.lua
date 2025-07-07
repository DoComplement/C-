
-- this file is intended to be built with srlua then placed in an environment path
-- args -> pwdgen %length% %quantity%

-- 84 characters
local ra = ''
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()?[]_`~;:@#$%^&*+=-."

do
    local t,x = {},{}
    for i = 1,84 do
        t[i] = i
    end
    for i = 84,1,-1 do
        x[85 - i] = table.remove(t, math.random(i))
    end

	for i,v in ipairs(x)do
		ra = ra .. string.sub(alphabet, v, v)
	end
end

local size,quantity = tonumber(arg[1]),tonumber(arg[2])
assert(size > 0 and quantity > 0, 'invalid dimensions')

for x=1,quantity do
     local pass = string.sub(alphabet, math.random(82)):sub(1,1)    -- last 2 characters in alphabet are valid starting password characters

    for i = 1,size - 1 do
        i = math.random(84)
        pass = pass .. string.sub(ra, i,i)
    end

    print(pass)
end
