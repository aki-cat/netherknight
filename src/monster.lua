
local monsters = basic.pack 'database.monsters'

local entity = require 'entity'

local monster = entity:new {
  species = 'slime',
  __type = 'monster'
}

function monster:__init ()
  self.size = monsters[self.species].size
  self.maxhp = monsters[self.species].maxhp or self.maxhp
  self.attack = monsters[self.species].attack
  self.think = monsters[self.species].update
end

function monster:on_death ()
  hump.signal.emit('entity_dying', self)
  audio:playSFX('Die')
  self.timer:after(0.4, function()
    hump.signal.emit('entity_death', self)
  end)
end

function monster:on_collision (somebody)
  if somebody:get_type() == 'attack' then
    self:take_damage(somebody.attack, somebody.pos)
  elseif somebody:get_type() == 'player' then
    somebody:take_damage(self.attack, self.pos)
  else
    self:stop()
  end
end

function monster:update (args)
  entity.update(self)
  if self.think and type(self.think) == 'function' then self:think() end
  hump.signal.emit('entity_turn', self, self.dir)
end

return monster
