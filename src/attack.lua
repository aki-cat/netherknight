
local attack = module.entity:new {
  __type = 'attack'
}

function attack:__init ()
  self.attack = 1
end

function attack:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    audio:playSFX('Hurt')
    somebody:take_damage(self.attack, self.pos)
  end
end

--function attack:draw ()
  -- deletes parent draw call
--end

return attack
