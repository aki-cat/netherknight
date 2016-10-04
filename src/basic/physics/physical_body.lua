
local physical_body = require 'basic.physics.collision_area' :new {
  __type = 'physical_body'
}

function physical_body:unnocupy_same_space (somebody)
  -- what
end

function physical_body:check_collision (somebody)
  local actor_self, actor_other = self:layer_collision(somebody)
  local colliding = self:rectangle_collision(somebody)
  if colliding then
    if actor_self then self:on_collision(somebody) end
    if actor_other then somebody:on_collision(self) end
  end
end

return physical_body
