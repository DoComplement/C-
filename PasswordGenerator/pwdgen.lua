
-- this file is intended to be built with srlua then placed in an environment path
-- args -> pwdgen %length% %quantity%

-- 84 characters
local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!()?[]_`~;:@#$%^&*+=-."
local ra = ''

local function permutation(len)
    local t,x = {},{}
    for i = 1,len do
        t[i] = i
    end
    for i = 1,len do
        x[i] = table.remove(t, math.random(#t))
    end

    return x
end

for i,v in ipairs(permutation(84))do
    ra = ra .. string.sub(alphabet, v, v)
end

local function password(len)
    local pass = string.sub(alphabet, math.random(82)):sub(1,1)    -- last 2 characters in alphabet are valid starting password characters

    for i,v in ipairs(permutation(len - 1))do
        i = math.random(84)
        pass = pass .. string.sub(ra, i,i)
    end

    print(pass)
end

local size,quantity = tonumber(arg[1]),tonumber(arg[2])
assert(size > 0 and quantity > 0, 'invalid dimensions')

for _=1,quantity do
    password(size)
end
