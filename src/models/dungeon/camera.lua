
local camera = require 'model' :new {}

function camera:update ()
  local cam = self:get_pool()[1]
  cam:update()
end

function camera:get_camera ()
  local cam = self:get_pool()[1]
  return cam
end

function camera:draw ()
  local cam = self:get_pool()[1]
  cam:draw()
end

return camera:new {}
