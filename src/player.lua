
local player = module.entity:new {
  __type = 'player'
}

function player:__init ()
  self.maxhp = 10
  self.locked = false
end

function player:on_collision (somebody, h, v)
  if somebody:get_type() == 'monster' then
    if not somebody.invincible then
      self:take_damage(somebody.attack, somebody.pos)
    end
  elseif somebody:get_type() == 'collectable' or somebody:get_type() == 'money' then
    somebody:on_collision(self)
  elseif somebody:get_type() ~= 'attack' then
    self:stop(h, v)
  end
end

function player:on_death ()
  hump.signal.emit('entity_slain', self)
  self.timer:after(1, function ()
    audio:silent()
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
  module.entity.update(self) -- call entity update
  hump.signal.emit('check_player_position', self.pos)
end

function player:draw ()
  module.entity.draw(self) -- call entity draw
end

return player
