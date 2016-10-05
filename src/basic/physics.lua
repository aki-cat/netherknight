
local physics = require 'basic.prototype' :new {
  __type = 'physics'
}

function physics:__init ()
  -- body...
  self.signals = require 'basic.signal' :new {}
  self.dynamic_bodies = {}
  self.static_bodies = {}
end

function physics:update_movement ()
  for b in pairs(self.dynamic_bodies) do
    if b.speed then
      b:deaccelerate()
      b.pos:add(b:get_speed())
    end
  end
end

function physics:update_collision ()
  local iterate = require 'basic.iterate'
  for b in pairs(self.dynamic_bodies) do
    for c in iterate.other(self.dynamic_bodies, b) do
      physics:check_collision(b, c)
    end
    for s in pairs(self.static_bodies) do
      physics:check_collision(b, s)
    end
    self.signals:queue('body_position', b)
  end
end

function physics:layer_collision (b1, b2)
  local this_collides, that_collides = false, false
  for i = 1, 16 do
    if b2.layers[i] and b1.masks[i] then this_collides = true end
    if b2.masks[i] and b1.layers[i] then that_collides = true end
  end
  return this_collides, that_collides
end

function physics:rectangle_collision (b1, b2)
  local colliding = true
  local top1, right1, bottom1, left1 = b1:get_edges()
  local top2, right2, bottom2, left2 = b2:get_edges()
  if top1 > bottom2 then colliding = false end
  if left1 > right2 then colliding = false end
  if right1 < left2 then colliding = false end
  if bottom1 < top2 then colliding = false end
  return colliding
end

function physics:check_collision (b1, b2)
  local intersect = self:rectangle_collision(b1, b2)
  local b1_act, b2_act = self:layer_collision(b1, b2)
  if intersect then
    if b1_act then self.signals:queue('body_collision', b1, b2) end
    if b2_act then self.signals:queue('body_collision', b2, b1) end
  end
end

function physics:get_last_valid_position (dynamic_body, collision_map)
  local clone = dynamic_body:clone()
  local lastpos = clone:get_pos() - clone:get_speed()
  for n = 1, 6 do
    local e = 2^n
    local nextpos = lastpos + clone:get_speed() / e
    clone:set_pos(nextpos:unpack())
    local t, r, b, l = clone:get_edges()
    if not collision_map:is_area_occupied(l, t, r - l, b - t) then
      lastpos:set(nextpos:unpack())
    end
  end
  local t, r, b, l = clone:get_edges()
  if not collision_map:is_area_occupied(l, t, r - l, b - t) then
    return clone:get_pos()
  else
    return dynamic_body:get_pos() - dynamic_body:get_speed()
  end
end

function physics:get_axis_movement (dynamic_body, collision_map)
  local clone = dynamic_body:clone() -- we assume it's not colliding
  local vertical = clone:get_speed()
  local horizontal = clone:get_speed()
  vertical.x = 0
  horizontal.y = 0
  clone:set_pos((clone:get_pos() + horizontal):unpack())
  local t, r, b, l = clone:get_edges()
  if collision_map:is_area_occupied(l, t, r - l, b - t) then
    clone:set_pos((clone:get_pos() - horizontal):unpack())
  end
  clone:set_pos((clone:get_pos() + vertical):unpack())
  local t, r, b, l = clone:get_edges()
  if collision_map:is_area_occupied(l, t, r - l, b - t) then
    clone:set_pos((clone:get_pos() - vertical):unpack())
  end
  local t, r, b, l = clone:get_edges()
  if collision_map:is_area_occupied(l, t, r - l, b - t) then
    return dynamic_body:get_pos()
  else
    return clone:get_pos()
  end
end

function physics:treat_collision (dynamic_body, collision_map)
  -- get next closest movable position
  local nextpos = self:get_last_valid_position(dynamic_body, collision_map)
  dynamic_body:set_pos(nextpos:unpack())

  -- try to move to each axis
  local nextpos = self:get_axis_movement(dynamic_body, collision_map)
  dynamic_body:set_pos(nextpos:unpack())
end

function physics:add_dynamic_body (b)
  self.dynamic_bodies[b] = b
end

function physics:remove_dynamic_body(b)
  self.dynamic_bodies[b] = nil
end

function physics:add_static_body (b)
  self.static_bodies[b] = b
end

function physics:remove_static_body(b)
  self.static_bodies[b] = nil
end

function physics:clear_bodies ()
  for b in pairs(self.dynamic_bodies) do
    self.dynamic_bodies[b] = nil
  end
  for s in pairs(self.static_bodies) do
    self.static_bodies[b] = nil
  end
end

function physics:update ()
  self:update_movement()
  self:update_collision()
  self.signals:update()
end

return physics:new {}
