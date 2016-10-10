
local body = require 'element' :new {
  'knight', -8000, -8000,
  __type = 'body'
}

function body:__init ()
  local shape = self[1]
  local size = require 'database.sizes.physical'[shape]
  self.dynamics = require 'basic.physics.dynamic_body' :new {
    self[2], self[3], size[1], size[2],
  }
end

function body:get_physics ()
  return self.dynamics
end

function body:update ()
  self:get_physics():update()
end

return body
