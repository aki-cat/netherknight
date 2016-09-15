
local epsilon = 5e-9

local sprites = basic.pack 'database.sprites'

local player = basic.prototype:new {
  0, 0,
  sprite = sprites.slime,
  __type = 'player'
}

function player:__init ()
  self.pos = basic.vector:new { self[1], self[2] }
  self.speed = basic.vector:new {}
  self.sprite = basic.prototype:new (self.sprite)
  self.sprite[2] = self.sprite.animations.idle.quads[1]
  self[1], self[2] = nil, nil
end

function player:update ()
  self:deaccelerate()
  self.pos:add(self.speed)
  self.sprite[3], self.sprite[4] = self.pos:unpack()
end

function player:draw ()
  love.graphics.draw(unpack(self.sprite))
end

function player:move (acc)
  self.speed:add(acc)
end

function player:deaccelerate ()
  self.speed:mul(0.8)
  if self.speed * self.speed < epsilon then
    self.speed:set(0, 0)
  end
end

return player
