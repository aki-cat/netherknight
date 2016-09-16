
local monsters = basic.pack 'database.monsters'

local monster = physics.dynamic_body:new {
  species = 'slime',
  __type = 'monster'
}

function monster:__init ()
  self.maxhp = monsters[self.species].maxhp or self.maxhp
  self.attack = monsters[self.species].attack
  self.think = monsters[self.species].update
end

function monster:on_collision (somebody)
  self:stop()
end

return monster
