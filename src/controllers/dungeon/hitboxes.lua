
local hitboxes = require 'controller' :new { 'dungeon' }

function hitboxes:__init ()
  local hitboxes_model = self:get_model('hitboxes')

  -- initialise actions
  self:register_action('death', function (id)
    self.timer:after( 0.1, function ()
      hitboxes_model:remove_element(id)
    end)
  end)

  self:register_action('position', function (id, pos)
    local hitbox = hitboxes_model:get_element(id)
    if not hitbox then return end
    hitbox:set_pos(pos)
  end)
end

return hitboxes:new {}
