
local monsters = basic.pack 'database.monsters'

local monster = physics.dynamic_body:new {
  species = 'slime',
  __type = 'monster'
}

function monster:__init ()
  self.size:set(monsters[self.species].width, monsters[self.species].height)
  self.maxhp = monsters[self.species].maxhp or self.maxhp
  self.attack = monsters[self.species].attack
  self.think = monsters[self.species].update
end

function monster:on_collision (somebody)
  if not somebody:get_type() == 'attack' then self:stop() end
end

return monster
