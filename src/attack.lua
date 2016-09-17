
local attack = physics.collision_body:new {
  __type = 'attack'
}

function attack:__init ()
  self.attack = 1
end

function attack:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    somebody:take_damage(self.attack)
    somebody:repulse(self.pos)
  end
end

return attack
