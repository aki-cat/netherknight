
local collision_area = basic.prototype:new {
  0, 0, 0, 0, -- x, y, w, h
  centred = false,
  __type = 'collision_area'
}

local LAYERS_TOTAL = 16

function collision_area:__init ()
  self.pos = basic.vector:new { self[1], self[2] }
  self.size = basic.vector:new { self[3], self[4] }
  self.layers = {}
  self.masks = {}
  for i = 1, LAYERS_TOTAL do
    if i == 1 then self.layers[i], self.masks[i] = true, true
    else self.layers[i], self.masks[i] = false, false end
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

function collision_area:layer_collision (other)
  local this_collides, that_collides = false, false
  for i = 1, LAYERS_TOTAL do
    if other.layers[i] and self.masks[i] then
      this_collides = true
    elseif other.masks[i] and self.layers[i] then
      that_collides = true
    end
  end
  return this_collides, that_collides
end

function collision_area:rectangle_collision (other)
  local colliding = true
  local rect1, rect2 = {
    top_left     = self.centred and self.pos - self.size / 2 or self.pos,
    bottom_right = self.centred and self.pos + self.size / 2 or self.pos + self.size,
  }, {
    top_left     = other.centred and other.pos - other.size / 2 or other.pos,
    bottom_right = other.centred and other.pos + other.size / 2 or other.pos + other.size,
  }

  if rect1.top_left.x > rect2.bottom_right.x then colliding = false end
  if rect1.top_left.y > rect2.bottom_right.y then colliding = false end
  if rect1.bottom_right.x < rect2.top_left.x then colliding = false end
  if rect1.bottom_right.y < rect2.top_left.y then colliding = false end

  return colliding
end

function collision_area:check_collision (somebody)
  local intersect = self:rectangle_collision(somebody)
  local actor_self, actor_other = self:layer_collision(somebody)

  if intersect then
    if actor_self then self:on_collision(somebody) end
    if actor_other then somebody:on_collision(self) end
  end
end

function collision_area:on_collision (somebody)
  -- implement on child
end

return collision_area
