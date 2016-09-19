
local entity = require 'entity'

local player = entity:new {
  __type = 'player'
}

function player:__init ()
  self.locked = false
end

function player:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    audio:playSFX('Hurt')
    self:take_damage(somebody.attack, somebody.pos)
  elseif somebody:get_type() == 'collectable' then
    audio:playSFX('Get')
    table.insert(gamedata.inventory, somebody.item)
    somebody.damage = 99999
  elseif somebody:get_type() ~= 'attack' then
    self:stop()
  end
end

function player:lock (time)
  self.timer:after(time, function() self:unlock() end)
  self.locked = true
end

function player:unlock ()
  self.locked = false
end

function player:draw ()
  entity.draw(self) -- call entity draw
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  love.graphics.printf(
    "PLAYER",
    globals.unit * (self.pos.x - self.size.x), globals.unit * ((self.pos.y - self.size.y) - 0.5),
    globals.unit * self.size.x * 2,
    "center"
  )
  love.graphics.pop()
end

return player
