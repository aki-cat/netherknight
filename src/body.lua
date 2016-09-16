
local body = basic.prototype:new {
  0, 0, 0, 0,
  __type = 'body'
}

local directions = {
  right      = math.pi * 0/4,
  down_right = math.pi * 1/4,
  down       = math.pi * 2/4,
  down_left  = math.pi * 3/4,
  left       = math.pi * 4/4,
  up_left    = math.pi * 5/4,
  up         = math.pi * 6/4,
  up_right   = math.pi * 7/4
}

function body:__init ()
  self.maxhp = 10
  self.dmg = 0
  self.timer = hump.timer.new()
  self.locked = false
  self.pos = basic.vector:new { self[1], self[2] }
  self.size = basic.vector:new { self[3], self[4] }
  self.speed = basic.vector:new {}
  self.dir = 'down'
  self[1], self[2] = nil, nil
end

function body:update ()
  self.timer:update(delta)
  self:deaccelerate()
  self.pos:add(self.speed)
  if self.think and type(self.think) == 'function' then self:think() end
end

function body:draw ()
end

function body:move (acc)
  self.speed:add(acc)
end

function body:deaccelerate ()
  self.speed:mul(0.8)
  if self.speed * self.speed < globals.epsilon then
    self.speed:set(0, 0)
  end
end

function body:face(dname)
  self.dir = dname
end

function body:getdirection()
  return directions[self.dir]
end

function body:lock (time)
  self.timer:after(time, function() self:unlock() end)
  self.locked = true
end

function body:unlock ()
  self.locked = false
end

function body:checkandcollide (anybody)
  local body_top_left = self.pos - self.size / 2
  local body_bottom_right = self.pos + self.size / 2
  local anybody_top_left = anybody.pos - anybody.size / 2
  local anybody_bottom_right = anybody.pos + anybody.size / 2

  local colliding = true
  if body_top_left.x > anybody_bottom_right.x then colliding = false end
  if body_top_left.y > anybody_bottom_right.y then colliding = false end
  if body_bottom_right.x < anybody_top_left.x then colliding = false end
  if body_bottom_right.y < anybody_top_left.y then colliding = false end

  if colliding then
    hump.signal.emit('body_collision', self, anybody)
  end
end

return body
