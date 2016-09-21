
--[[ Collision Body
new -> {
  [1]: x
  [2]: y
  [3]: width/radius
  [4]: height
  shape: 'rectangle' | 'circle'
  centred: true | false
}

To verify collision, call `collision_body:checkandcollide()` and pass the other body as parameter
To specify what happens on collision, rewrite on instance the method `collision_body:on_collision()`

]]

local collision_body = basic.prototype:new {
  0, 0, 0, 0,
  shape = 'rectangle',
  centred = false,
  __type = 'collision_body'
}

function collision_body:__init ()
  self.pos = basic.vector:new { self[1], self[2] }
  if self.shape == 'rectangle' then
    self.size = basic.vector:new { self[3], self[4] }
  elseif self.shape == 'circle' then
    self.size = self[3]
  else
    error("undefined shape")
  end
  self[1], self[2], self[3], self[4] = nil, nil, nil, nil
end

function collision_body:update ()
end

function collision_body:draw ()
end

function collision_body:on_collision (somebody)
  somebody:stop()
end

local function circle_rect_collision (circle, rect)
  local colliding = false
  local top_left = rect.centred and rect.pos - rect.size/2 or rect.pos
  local bottom_right = rect.centred and rect.pos + rect.size/2 or rect.pos + rect.size
  local CX, CY = circle.pos:unpack()
  local L = top_left.x
  local T = top_left.y
  local R = bottom_right.x
  local B = bottom_right.y
  local closest = basic.vector:new{
    math.max(math.min(CX,R),L),
    math.max(math.min(CY,B),T),
  }
  local normal = closest - circle.pos
  if normal * normal <= circle.size * circle.size then
    colliding = true
  end
  return colliding
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
  local body_top_left = rect1.centred and rect1.pos - rect1.size/2 or rect1.pos
  local body_bottom_right = rect1.centred and rect1.pos + rect1.size/2 or rect1.pos + rect1.size
  local anybody_top_left = rect2.centred and rect2.pos - rect2.size/2 or rect2.pos
  local anybody_bottom_right = rect2.centred and rect2.pos + rect2.size/2 or rect2.pos + rect2.size

  if body_top_left.x > anybody_bottom_right.x then
    colliding = false
  end
  if body_top_left.y > anybody_bottom_right.y then
    colliding = false
  end
  if body_bottom_right.x < anybody_top_left.x then
    colliding = false
  end
  if body_bottom_right.y < anybody_top_left.y then
    colliding = false
  end

  return colliding
end

function collision_body:checkandcollide (somebody)
  local colliding
  if self.shape == 'rectangle' and somebody.shape == 'rectangle' then
    colliding = rect_rect_collision(self, somebody)
  elseif self.shape == 'rectangle' and somebody.shape == 'circle' then
    colliding = circle_rect_collision(somebody, self)
  elseif self.shape == 'circle' and somebody.shape == 'rectangle' then
    colliding = circle_rect_collision(self, somebody)
  elseif self.shape == 'circle' and somebody.shape == 'circle' then
    colliding = circle_circle_collision(self, somebody)
  end
  if colliding then
    print('collision!', self:get_type(), somebody:get_type())
    self:on_collision(somebody)
  end
end

return collision_body
