
if (lrgb) then return end

require'newcclosure'

local lrgb = {}


-------------------------- RGB-LUMINANCE FUNCTIONS --------------------------

lrgb.rgb2lum = newcclosure(function(r,g,b)
	return math.pow((0.299 * r + 0.587 * g + 0.114 * b), 1/2.2)
end)

lrgb.rgbcomp = newcclosure(function(r,g,b)
	return 255 - r, 255 - g, 255 - b
end)

-------------------------- HEX FUNCTIONS --------------------------

lrgb.rgb2hex = newcclosure(function(r,g,b)
	local num = (r << 16)~(g << 8)~(b)
	
	return string.format("#%06X", num)
end)

lrgb.hex2rgb = newcclosure(function(hex)
	local num = tonumber(string.match(hex, "%d+"), 16)
	
	return (num >> 16), (num >> 8)&255, num&255
end)

-- rgbhex complement
lrgb.hexcomp = newcclosure(function(hex)
	local r,g,b = lrgb.hex2rgb(hex)
	
	return lrgb.rgb2hex(255 - r, 255 - g, 255 - b)
end)



-------------------------- HSV FUNCTIONS --------------------------

lrgb.rgb2hsv = newcclosure(function(r,g,b)

	r,g,b = r/255, g/255, b/255
	local max = math.max(r,g,b)
	local min = math.min(r,g,b)
	
	local delta,hue = max-min
	if(max == min)then 
		hue = 0
	elseif(r == max)then
		hue = ((g-b)/delta)%6
	elseif(g == max)then
		hue =  (b-r)/delta + 2.0
	else
		hue =  (r-g)/delta + 4.0
	end
	
	hue = hue*60
	if(max == 0)then
		return hue, 0, 0
	end
	
	return hue, delta/max, max
end)

lrgb.hsv2rgb = newcclosure(function(h,s,v)
	local c = s*v
	local x = c * (1 - math.abs((h/60)%2 - 1))
	local m = v - c
	
	local R,G,B
	if (0 <= h < 60) then
		R,G,B = c,x,0
	elseif (60 <= h < 120) then
		R,G,B = x,c,0
	elseif (120 <= h < 180) then
		R,G,B = 0,c,x
	elseif (180 <= h < 240) then
		R,G,B = 0,x,c
	elseif (240 <= h < 300) then
		R,G,B = x,0,c
	else
		R,G,B = c,0,x
	end
	
	return (R + m)*255, (G + m)*255, (B + m)*255
end)

lrgb.hsvcomp = newcclosure(function(h,s,v) 
	local r,g,b = lrgb.hsv2rgb(h,s,v)
	
	return lrgb.rgb2hsv(255 - r, 255 - g, 255 - b)
end)

-------------------------- CMYK FUNCTIONS --------------------------

lrgb.rgb2cmyk = newcclosure(function(r,g,b)
	local R,G,B = r/255, g/255, b/255
	
	local k = 1 - math.max(R,G,B)
	local c = (1 - R - k) / (1 - k)
	local m = (1 - G - k) / (1 - k)
	local y = (1 - B - k) / (1 - k)
	
	return c,m,y,k
end)

lrgb.cmyk2rgb = newcclosure(function(c,m,y,k)
	local r = 255*(1 - c)*(1 - k)
	local g = 255*(1 - m)*(1 - k)
	local b = 255*(1 - y)*(1 - k)
	
	return r,g,b
end)

lrgb.cmykcomp = newcclosure(function(c,m,y,k)
	local r,g,b = lrgb.cmyk2rgb(c,m,y,k)

	return lrgb.rgb2cmyk(255 - r, 255 - g, 255 - b)
end)

-------------------------- HSL FUNCTIONS --------------------------

lrgb.rgb2hsl = newcclosure(function(r,g,b)
	local R,G,B = r/255,g/255,b/255
	local max = math.max(R,G,B)
	local min = math.min(R,G,B)
	
	local delta,hue = max-min	
	if (delta == 0) then
		hue = 0
	elseif (max == R) then
		hue = 60 * (((G - B)/delta)%6)
	elseif (max == G) then
		hue = 60 * (2 + (B - R)/delta)
	else
		hue = 60 * (4 + (R - G)/delta)
	end
	
	local l = (max + min)/2
	if (delta == 0) then
		return hue,0,l
	end
	return hue, delta / (1 - math.abs(2*l - 1)), l
end)


lrgb.hsl2rgb = newcclosure(function(h,s,l)
	
	local c = s * (1 - math.abs(2*l - 1))
	local x = c * (1 - math.abs((h/60)%2 - 1))
	local m = l - c/2
	
	local R,G,B
	local R,G,B
	if (0 <= h < 60) then
		R,G,B = c,x,0
	elseif (60 <= h < 120) then
		R,G,B = x,c,0
	elseif (120 <= h < 180) then
		R,G,B = 0,c,x
	elseif (180 <= h < 240) then
		R,G,B = 0,x,c
	elseif (240 <= h < 300) then
		R,G,B = x,0,c
	else
		R,G,B = c,0,x
	end
	
	return (R + m)*255, (G + m)*255, (B + m)*255
end)

lrgb.hslcomp = newcclosure(function(h, s, l)
	local r,g,b = lrgb.hsl2rgb(h, s, l)
	
	return lrgb.rgb2hsl(255 - r, 255 - g, 255 - b)
end)

-------------------------- EXTRA CONVERSION FUNCTIONS --------------------------

-- not really necessary tbh, all extra conversion can be done personally because
-- it is simple enough and these functions are enough on their own  


-------------------------- SORTING FUNCTIONS --------------------------

-- sorting functions could also be implemented personally,
--[[ TYPICALLY (standard tbh) is to sort via hsl:

lrgb.step = newcclosure(function(r,g,b,repetitions)
	
	local lum   = lrgb.rgb2lum(r,g,b)
	local h,s,v = lrgb.rgb2hsv(r,g,b)
	
	local h2 = h*repetitions
	local v2 = v*repetitions
	
	if ((h&1) == 1) then
		v2  = repetitions - v2
		lum = repetitions - lum
	end
     
    return h2, lum, v2
end)

]]



_ENV.lrgb = lrgb
