
local monsters = basic.pack 'database.monsters'

local monster = require 'entity' :new {
  species = 'slime',
  __type = 'monster'
}

function monster:__init ()
  self.size = monsters[self.species].size
  self.maxhp = monsters[self.species].maxhp or self.maxhp
  self.attack = monsters[self.species].attack
  self.think = monsters[self.species].update
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

return monster
