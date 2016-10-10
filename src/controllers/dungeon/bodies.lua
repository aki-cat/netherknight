
local bodies = require 'controller' :new { 'dungeon' }

function bodies:__init ()
  local DEATH_TIME = 0.6
  local physics_model = self:get_model('physics')
  local hitboxes_model = self:get_model('hitboxes')

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
    local attacked = hitboxes_model:get_element(id):get_area()
    local attacker = hitboxes_model:get_element(harmful_id):get_area()
    physical_body:impulse(attacked:get_pos() - attacker:get_pos(), 0.2)
  end)

  self:register_action('move', function (id, acc)
    local body = physics_model:get_element(id)
    if not body then return end

    local physical_body = body:get_physics()
    physical_body:move(acc)
  end)

end

return bodies:new {}
