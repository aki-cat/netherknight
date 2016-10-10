
local camera = require 'controller' :new { 'dungeon' }

function camera:__init ()
  local camera_model = self:get_model('camera')
  local map = self:get_model('map')

  -- initialise actions
  self:register_action('position', function (id, pos)
    local cam = camera_model:get_element(id)
    if not cam then return end
    cam:set_target(pos)
  end)

  self:register_action('set_room', function (id)
    local room = map:get_element(id)
    local cam = camera_model:get_camera()
    if not room or not cam then return end

    local x, y, w, h = 0, 0, room:get_width() + 2 * room:get_margin(), room:get_height() + 2 * room:get_margin()
    cam:set_limits(x, y, w, h)
    print("CAMERA LIMITS:", x, y, w, h)
    print("CAMERA SET!")
  end)
end

return camera:new {}
