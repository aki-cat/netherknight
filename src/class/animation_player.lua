
local globals = require 'globals'

local defaultquad = { 0, 0, globals.unit, globals.unit, globals.unit, globals.unit }

local animation_player = class.object:new {
  animations = { default = false },
  current = 'default'
  __type = 'animation_player'
}

function animation_player:__init ()
  for k,anim in pairs(self.animations) do
    if anim.default then self.current = k end
  end
  self:play()
end

function animation_player:play (aname)
  if aname then self.current = aname end
  if self.animations[self.current] then
    self.animations[self.current]:play()
  end
end

function animation_player:stop ()
  if self.animations[self.current] then
    self.animations[self.current]:stop()
  end
end

function animation_player:getquad ()
  return self.animations[self.current].qid
end

function animation_player:update ()
  self:__super().update(self)
end

return animation_player
