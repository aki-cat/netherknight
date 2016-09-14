
local globals = require 'globals'
local class = orangelua.pack 'class'

local img  = love.graphics.newImage('assets/images/dummy.png')
local quad = love.graphics.newQuad(0, 0, globals.unit, globals.unit, img:getDimensions())
local x, y = 0, 0
local r = 0
local sx, sy = 1, 1
local ox, oy = globals.unit/2, globals.unit/2
local kx, ky = 0, 0

local sprite = class.object2d:new {
  img, quad, x, y, r, sx, sy, ox, oy, kx, ky,
  name = 'sprite',
  animation_info = {},
  __type = 'sprite'
}

function sprite:__init ()
  print('sprite init')
  print('sizing: ', self.sx, self.sy)
  animation_player = class.animation_player:new(self.animation_info)
  animation_player.name = 'animation_player'
  self.offset = class.vector:new{self.ox, self.oy}
  self:addchild(animation_player)
end

function sprite:__index (k)
  if k == 'img' then return self[1] end
  if k == 'quad' then return self[2] end
  if k == 'x' then return self[3] end
  if k == 'y' then return self[4] end
  if k == 'r' then return self[5] end
  if k == 'sx' then return self[6] end
  if k == 'sy' then return self[7] end
  if k == 'ox' then return self[8] end
  if k == 'oy' then return self[9] end
  if k == 'kx' then return self[10] end
  if k == 'ky' then return self[11] end
  if k == 'animation_info' then return end
  return getmetatable(self)[k]
end

function sprite:__newindex (k, v)
  if     k == 'img'  then rawset(self, 1, v)
  elseif k == 'quad' then rawset(self, 2, v)
  elseif k == 'x'    then self.pos.x = v
  elseif k == 'y'    then self.pos.y = v
  elseif k == 'r'    then rawset(self, 5, v)
  elseif k == 'sx'   then rawset(self, 6, v)
  elseif k == 'sy'   then rawset(self, 7, v)
  elseif k == 'ox'   then self.offset.x = v
  elseif k == 'oy'   then self.offset.y = v
  elseif k == 'kx'   then rawset(self, 10, v)
  elseif k == 'ky'   then rawset(self, 11, v)
  else rawset(self, k, v) end
end

function sprite:__update ()
  self[3], self[4] = self:getpos():unpack()
  self.ox, self.oy = self.offset:unpack()
  local animplayer = self:getchild('animation_player')
  self[2] = animplayer:getquad()
end

function sprite:__draw ()
  print(unpack(self))
  love.graphics.draw(unpack(self))
end

return sprite
