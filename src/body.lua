
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
  self.locktimer = hump.timer.new()
  self.locked = false
  self.pos = basic.vector:new { self[1], self[2] }
  self.size = basic.vector:new { self[3], self[4] }
  self.dir = 'down'
  self.speed = basic.vector:new {}
  self[1], self[2] = nil, nil
end

function body:update ()
  self.locktimer:update(delta)
  self:deaccelerate()
  self.pos:add(self.speed)
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
  self.locktimer:after(time, function() self:unlock() end)
  self.locked = true
end

function body:unlock ()
  self.locked = false
end

return body
