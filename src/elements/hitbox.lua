
local hitbox = require 'element' :new {
  'knight', 0, 0,
  __type = 'hitbox'
}

function hitbox:__init ()
  local shape = self[1]
  local size = require 'database.sizes.hitbox'[shape]
  self.area = require 'basic.physics.collision_area' :new {
    self[2], self[3], size[1], size[2], centred = true,
  }
  self.offset = require 'basic.vector' :new { size[3], size[4] }
end

function hitbox:get_area ()
  return self.area
end

function hitbox:get_offset ()
  return self.offset * 1
end

function hitbox:set_pos (pos)
  self.area:set_pos((pos + self.offset):unpack())
end

return hitbox
