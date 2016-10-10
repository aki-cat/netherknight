
local vector = require 'basic.vector'

local collision_area = require 'basic.prototype' :new {
  0, 0, 0, 0, -- x, y, w, h
  centred = false,
  __type = 'collision_area'
}

local LAYERS_TOTAL = 16

function collision_area:__init ()
  self.pos = vector:new { self[1], self[2] }
  self.size = vector:new { self[3], self[4] }
  self.layers = {}
  self.masks = {}
  for i = 1, LAYERS_TOTAL do
    self.layers[i], self.masks[i] = false, false
  end
end

function collision_area:set_layer (l)
  if l >= 1 and l <= LAYERS_TOTAL then self.layers[l] = true end
end

function collision_area:unset_layer (l)
  if l >= 1 and l <= LAYERS_TOTAL then self.layers[l] = false end
end

function collision_area:set_mask (m)
  if m >= 1 and m <= LAYERS_TOTAL then self.masks[m] = true end
end

function collision_area:unset_mask (m)
  if m >= 1 and m <= LAYERS_TOTAL then self.masks[m] = false end
end

function collision_area:set_pos (x, y)
  self.pos:set(x, y)
end

function collision_area:get_pos ()
  return self.pos * 1
end

function collision_area:set_size (w, h)
  self.size:set(w, h)
end

function collision_area:get_size ()
  return self.size * 1
end

function collision_area:get_top ()
  return self.centred and self.pos.y - self.size.y / 2 or self.pos.y
end

function collision_area:get_right ()
  return self.centred and self.pos.x + self.size.x / 2 or self.pos.x + self.size.x
end

function collision_area:get_bottom ()
  return self.centred and self.pos.y + self.size.y / 2 or self.pos.y + self.size.y
end

function collision_area:get_left ()
  return self.centred and self.pos.x - self.size.x / 2 or self.pos.x
end

function collision_area:get_edges ()
  return self:get_top(), self:get_right(), self:get_bottom(), self:get_left()
end

return collision_area
