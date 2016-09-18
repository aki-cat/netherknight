
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
  if somebody:get_type() == 'attack' then
    self:take_damage(somebody.attack)
    self:repulse(somebody.pos)
    self:stagger(globals.stagger)
  else
    self:stop()
  end
end

return monster
