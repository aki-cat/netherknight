
local collision_body = basic.prototype:new {
  0, 0, 0, 0,
  centred = true,
  __type = 'collision_body'
}

function collision_body:__init ()
  self.pos = basic.vector:new { self[1], self[2] }
  self.size = basic.vector:new { self[3], self[4] }
  self[1], self[2], self[3], self[4] = nil, nil, nil, nil
end

function collision_body:update ()
end

function collision_body:draw ()
end

function collision_body:on_collision (somebody)
  somebody:stop()
end

function collision_body:checkandcollide (anybody)
  local body_top_left
  local body_bottom_right
  local anybody_top_left
  local anybody_bottom_right
  local colliding = true

  if self.centred then
    body_top_left = self.pos - self.size / 2
    body_bottom_right = self.pos + self.size / 2
  else
    body_top_left = self.pos
    body_bottom_right = self.pos + self.size
  end
  if anybody.centred then
    anybody_top_left = anybody.pos - anybody.size / 2
    anybody_bottom_right = anybody.pos + anybody.size / 2
  else
    anybody_top_left = anybody.pos
    anybody_bottom_right = anybody.pos + anybody.size
  end

  if body_top_left.x > anybody_bottom_right.x then colliding = false end
  if body_top_left.y > anybody_bottom_right.y then colliding = false end
  if body_bottom_right.x < anybody_top_left.x then colliding = false end
  if body_bottom_right.y < anybody_top_left.y then colliding = false end

  if colliding then
    hump.signal.emit('entity_collision', self, anybody)
  end
end

return collision_body
