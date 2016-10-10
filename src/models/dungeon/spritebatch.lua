
local spritebatch = require 'model' :new {}

function spritebatch:__init ()
  self.current = false
end

function spritebatch:set_current (id)
  self.current = id
end

function spritebatch:draw ()
  if self.current then
    local tilemap = self:get_element(self.current)
    tilemap:draw()
  end
end

return spritebatch:new {}
