
local entity = require 'entity'

local player = entity:new {
  __type = 'player'
}

function player:__init ()
  self.maxhp = 10
  self.locked = false
end

function player:on_collision (somebody, h, v)
  if somebody:get_type() == 'monster' then
    self:take_damage(somebody.attack, somebody.pos)
  elseif somebody:get_type() == 'collectable' or somebody:get_type() == 'money' then
    somebody:on_collision(self)
  elseif somebody:get_type() ~= 'attack' then
    self:stop(h, v)
  end
end

function player:on_death ()
  audio:playSFX('Die')
  self.timer:after(0.3, function ()
    hump.signal.emit('gameover')
  end)
end

function player:lock (time)
  self.timer:after(time, function() self:unlock() end)
  self.locked = true
end

function player:unlock ()
  self.locked = false
end

function player:update ()
  entity.update(self) -- call entity update
  hump.signal.emit('check_player_position', self.pos)
end

function player:draw ()
  entity.draw(self) -- call entity draw
end

return player
