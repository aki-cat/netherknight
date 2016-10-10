
local bodies = require 'controller' :new { 'dungeon' }

function bodies:__init ()
  local DEATH_TIME = 0.6
  local physics_model = self:get_model('physics')

  -- initialise actions
  self:register_action('death', function (id)
    self.timer:after(DEATH_TIME, function ()
      physics_model:remove_element(id)
    end)
  end)

  self:register_action('take_damage', function (id, harmful_id, dmg, stagger)
    local body = physics_model:get_element(id)
    if not body then return end

    local physical_body = body:get_physics()
    local attacker = physics_model:get_element(harmful_id):get_physics()
    physical_body:repulse(attacker:get_pos())
  end)

  self:register_action('move', function (id, acc)
    local body = physics_model:get_element(id)
    if not body then return end

    local physical_body = body:get_physics()
    physical_body:move(acc)
  end)

end

return bodies:new {}
