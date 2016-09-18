
local attack = physics.collision_body:new {
  __type = 'attack'
}

function attack:__init ()
  self.attack = 1
end

function attack:on_collision (somebody)
  if somebody:get_type() == 'monster' then
    audio:playSFX('Hurt')
    somebody:take_damage(self.attack)
    print(frameid)
    somebody:repulse(self.pos)
    somebody:stagger(globals.stagger)
  end
end

return attack
