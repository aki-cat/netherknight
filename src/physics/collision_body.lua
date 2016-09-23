
--[[ Collision Body
new -> {
  [1]: x
  [2]: y
  [3]: width
  [4]: height
  centred: true | false
}

To verify collision, call `collision_body:checkandcollide()` and pass the other body as parameter
To specify what happens on collision, rewrite on instance the method `collision_body:on_collision()`

]]

local collision_body = basic.prototype:new {
  0, 0, 0, 0,
  centred = false,
  __type = 'collision_body'
}

function collision_body:__init ()
  self.pos = basic.vector:new { self[1], self[2] }
  self.size = basic.vector:new { self[3], self[4] }
end

function collision_body:update ()
end

function collision_body:draw ()
end

function collision_body:on_collision (somebody)
  somebody:stop()
end

local function circle_circle_collision (circle1, circle2)
  local colliding = false
  local normal = circle1.pos - circle2.pos
  if normal * normal <= (circle1.size + circle2.size) * (circle1.size + circle2.size) then
    colliding = true
  end
  return colliding
end

local function rect_rect_collision (rect1, rect2)
  local colliding = true

  if rect1.top_left.x > rect2.bottom_right.x then
    colliding = false
  end
  if rect1.top_left.y > rect2.bottom_right.y then
    colliding = false
  end
  if rect1.bottom_right.x < rect2.top_left.x then
    colliding = false
  end
  if rect1.bottom_right.y < rect2.top_left.y then
    colliding = false
  end

  return colliding
end

local function divide_collision_axis(body1, body2)
  local speedx, speedy = body1.speed:unpack()
  local speedx, speedy = basic.vector:new{speedx, 0}, basic.vector:new{0, speedy}
  local body1_x = body1.pos + speedx
  local body1_y = body1.pos + speedy
  local rect1_x = {
    top_left = body1.centred and body1_x - body1.size/2 or body1_x,
    bottom_right = body1.centred and body1_x + body1.size/2 or body1_x + body1.size,
  }
  local rect1_y = {
    top_left = body1.centred and body1_y - body1.size/2 or body1_y,
    bottom_right = body1.centred and body1_y + body1.size/2 or body1_y + body1.size,
  }
  local rect2 = {
    top_left = body2.centred and body2.pos - body2.size/2 or body2.pos,
    bottom_right = body2.centred and body2.pos + body2.size/2 or body2.pos + body2.size,
  }
  return rect_rect_collision(rect1_x, rect2), rect_rect_collision(rect1_y, rect2)
end

function collision_body:checkandcollide (somebody)
  local h, v = divide_collision_axis(self, somebody)
  if h or v then
    print('collision!', self:get_type(), somebody:get_type())
    self:on_collision(somebody, h, v)
  end
end

return collision_body
