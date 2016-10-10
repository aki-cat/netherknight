
local physics = {}
local vector = require 'basic.vector'

physics.__DIRECTION = {
  right      = vector:new { math.cos(math.pi * 0/4), math.sin(math.pi * 0/4), },
  down_right = vector:new { math.cos(math.pi * 1/4), math.sin(math.pi * 1/4), },
  down       = vector:new { math.cos(math.pi * 2/4), math.sin(math.pi * 2/4), },
  down_left  = vector:new { math.cos(math.pi * 3/4), math.sin(math.pi * 3/4), },
  left       = vector:new { math.cos(math.pi * 4/4), math.sin(math.pi * 4/4), },
  up_left    = vector:new { math.cos(math.pi * 5/4), math.sin(math.pi * 5/4), },
  up         = vector:new { math.cos(math.pi * 6/4), math.sin(math.pi * 6/4), },
  up_right   = vector:new { math.cos(math.pi * 7/4), math.sin(math.pi * 7/4), },
}

function physics.get_direction (name)
  return physics.__DIRECTION[name] * 1
end

function physics.layer_collision (b1, b2)
  local this_collides, that_collides = false, false
  for i = 1, 16 do
    if b2.layers[i] and b1.masks[i] then this_collides = true end
    if b2.masks[i] and b1.layers[i] then that_collides = true end
  end
  return this_collides, that_collides
end

function physics.rectangle_collision (b1, b2)
  local colliding = true
  local top1, right1, bottom1, left1 = b1:get_edges()
  local top2, right2, bottom2, left2 = b2:get_edges()
  if top1 > bottom2 then colliding = false end
  if left1 > right2 then colliding = false end
  if right1 < left2 then colliding = false end
  if bottom1 < top2 then colliding = false end
  return colliding
end

function physics.get_closest_position (b1, b2)
  local clone = b1:clone()
  local lastpos = clone:get_pos() - clone:get_speed()

  -- binary search for closest position
  for n = 1, 6 do
    local e = 2^n
    local nextpos = lastpos + clone:get_speed() / e
    clone:set_pos(nextpos:unpack())
    if not physics.rectangle_collision(clone, b2) then
      lastpos:set(nextpos:unpack())
    end
  end

  -- last check for collision on result
  if not physics.rectangle_collision(clone, b2) then
    return clone:get_pos()
  else
    return (b1:get_pos() - b1:get_speed())
  end
end

function physics.get_body_axis_movement (b1, b2)
  local clone = b1:clone() -- we assume it's not colliding

  -- get speed vector components
  local vertical = clone:get_speed()
  local horizontal = clone:get_speed()
  vertical.x = 0
  horizontal.y = 0

  -- try to move horizontally
  clone:set_pos((clone:get_pos() + horizontal):unpack())
  if physics.rectangle_collision(clone, b2) then
    --print("Could not move horizontally")
    b1.speed.x = 0
    clone:set_pos((clone:get_pos() - horizontal):unpack())
  end

  -- try to move vertically
  clone:set_pos((clone:get_pos() + vertical):unpack())
  if physics.rectangle_collision(clone, b2) then
    b1.speed.y = 0
    clone:set_pos((clone:get_pos() - vertical):unpack())
  end

  -- double check for diagonal mishaps
  if not physics.rectangle_collision(clone, b2) then
    return clone:get_pos()
  else
    return b1:get_pos()
  end
end

function physics.treat_body_collision (b1, b2)
  -- get next closest movable position
  local nextpos = physics.get_closest_position(b1, b2)
  b1:set_pos(nextpos:unpack())

  -- try to move to each axis
  local nextpos = physics.get_body_axis_movement(b1, b2)
  b1:set_pos(nextpos:unpack())
end

function physics.get_last_valid_position (dynamic_body, collision_map)
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

function physics.get_axis_movement (dynamic_body, collision_map)
  local clone = dynamic_body:clone() -- we assume it's not colliding
  local vertical = clone:get_speed()
  local horizontal = clone:get_speed()
  vertical.x = 0
  horizontal.y = 0

  clone:set_pos((clone:get_pos() + horizontal):unpack())
  local t, r, b, l = clone:get_edges()
  if collision_map:is_area_occupied(l, t, r - l, b - t) then
    clone:set_pos((clone:get_pos() - horizontal):unpack())
    dynamic_body.speed.x = 0
  end

  clone:set_pos((clone:get_pos() + vertical):unpack())
  local t, r, b, l = clone:get_edges()
  if collision_map:is_area_occupied(l, t, r - l, b - t) then
    clone:set_pos((clone:get_pos() - vertical):unpack())
    dynamic_body.speed.y = 0
  end

  local t, r, b, l = clone:get_edges()
  if collision_map:is_area_occupied(l, t, r - l, b - t) then
    return dynamic_body:get_pos()
  else
    return clone:get_pos()
  end
end

function physics.treat_collision (dynamic_body, collision_map)
  -- get next closest movable position
  local nextpos = physics.get_last_valid_position(dynamic_body, collision_map)
  dynamic_body:set_pos(nextpos:unpack())

  -- try to move to each axis
  local nextpos = physics.get_axis_movement(dynamic_body, collision_map)
  dynamic_body:set_pos(nextpos:unpack())
end

return physics
