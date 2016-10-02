
local attack = module.entity:new {
  __type = 'attack'
}

function attack:__init ()
  self.attack = 1
end

function attack:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    local dmg = self.attack + gamedata.weapon:generate_dmg()
    somebody:take_damage(dmg, self.pos)
  end
end

function attack:draw ()
  -- deletes parent draw call
end

return attack
