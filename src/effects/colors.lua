
local colors = {}

local function HSL (h, s, l, a)
  h = math.fmod(h, 256*6 + 1)
  if s<=0 then return l,l,l,a end
  h, s, l = h/256*6, s/255, l/255
  local c = (1-math.abs(2*l-1))*s
  local x = (1-math.abs(h%2-1))*c
  local m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  end return (r+m)*255,(g+m)*255,(b+m)*255,a
end

function colors.setHSLA (h,s,l,a)
  love.graphics.setColor(HSL(h,s,l,a))
end

function colors.setRGBA (r,g,b,a)
  love.graphics.setColor(r,g,b,a)
end

function colors.reset ()
  love.graphics.setColor(255,255,255,255)
end

return colors
