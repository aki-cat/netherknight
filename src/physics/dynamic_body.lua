
local dynamic_body = physics.collision_body:new {
  __type = 'dynamic_body'
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

function dynamic_body:__init ()
  self.speed = basic.vector:new {}
  self.dir = 'down'
end

function dynamic_body:update ()
  self:deaccelerate()
  self.pos:add(self.speed)
end

function dynamic_body:draw ()
end

function dynamic_body:repulse (point)
  local antigravity = self.pos - point
  local distsqr = antigravity * antigravity
  self:move(0.04 * antigravity:normalized() / distsqr)
end

function dynamic_body:on_collision (somebody)
  -- do stuff
end

function dynamic_body:move (acc)
  self.speed:add(acc)
end

function dynamic_body:stop ()
  self.pos:sub(self.speed)
  self.speed:set()
end

function dynamic_body:deaccelerate ()
  self.speed:mul(0.8)
  if self.speed * self.speed < globals.epsilon then
    self.speed:set(0, 0)
  end
end

function dynamic_body:face(dname)
  self.dir = dname
end

function dynamic_body:getdirection()
  return directions[self.dir]
end

return dynamic_body
