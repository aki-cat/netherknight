
local behaviours = require 'controller' :new { 'dungeon' }

function behaviours:__init ()
  local behaviours_model = self:get_model('behaviours')
  local player_model = self:get_model('player')
  local physics_model = self:get_model('physics')
  local hitboxes_model = self:get_model('hitboxes')

  -- initialise actions
  self:register_action('death', function (id)
    behaviours_model:remove_element(id)
  end)

  self:register_action('chase', function (id, speed)
    local chaser_body = physics_model:get_element(id)
    local player = player_model:get_player()
    if not chaser_body or not player then return end

    local player_id = player:get_id()
    local player_body = hitboxes_model:get_element(player_id)
    if not player_id or not player_body then return end

    local target = player_body:get_area():get_pos()
    local position = chaser_body:get_physics():get_pos()
    local movement = (target - position):normalized()
    chaser_body:get_physics():move(speed * movement)
  end)

end

return behaviours:new {}
