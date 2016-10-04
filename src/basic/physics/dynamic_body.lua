
local dynamic_body = require 'basic.physics.physical_body' :new {
  centred = true,
  DIRECTION = {
    right      = basic.vector:new { math.cos(math.pi * 0/4), math.sin(math.pi * 0/4), },
    down_right = basic.vector:new { math.cos(math.pi * 1/4), math.sin(math.pi * 1/4), },
    down       = basic.vector:new { math.cos(math.pi * 2/4), math.sin(math.pi * 2/4), },
    down_left  = basic.vector:new { math.cos(math.pi * 3/4), math.sin(math.pi * 3/4), },
    left       = basic.vector:new { math.cos(math.pi * 4/4), math.sin(math.pi * 4/4), },
    up_left    = basic.vector:new { math.cos(math.pi * 5/4), math.sin(math.pi * 5/4), },
    up         = basic.vector:new { math.cos(math.pi * 6/4), math.sin(math.pi * 6/4), },
    up_right   = basic.vector:new { math.cos(math.pi * 7/4), math.sin(math.pi * 7/4), },
  },
  SPEEDLIMIT = 0.8,
  EPSILON = 1e-3,
  __type = 'dynamic_body'
}

function dynamic_body:__newindex (k, v)
  local static_val_error = "Don't change class static values!"
  if     k == 'DIRECTION'  then return error (static_val_error)
  elseif k == 'SPEEDLIMIT' then return error (static_val_error)
  elseif k == 'EPSILON'    then return error (static_val_error)
  else rawset(self, k, v) end
end

function dynamic_body:__init ()
  self.speed = basic.vector:new {}
end

function dynamic_body:update ()
  self:deaccelerate()
  self.pos:add(self.speed)
end

function dynamic_body:repulse (point)
  local antigravity = self.pos - point
  antigravity:normalize()
  local sqrmag = antigravity * antigravity
  if sqrmag == math.huge or sqrmag ~= sqrmag then
    local angle = math.pi * love.math.random(0,7) / 4
    antigravity = basic.vector:new { math.cos(angle), math.sin(angle) }
  end
  self:move(0.4 * antigravity)
end

function dynamic_body:move (acc)
  self.speed:add(acc)
end

function dynamic_body:stop (h, v)
  self.pos:sub(self.speed)
  self.speed:set()
end

function dynamic_body:deaccelerate ()
  self.speed:mul(self.SPEEDLIMIT)
  if self.speed * self.speed < self.EPSILON * self.EPSILON then
    self.speed:set(0, 0)
  end
end

function dynamic_body:get_speed ()
  return self.speed * 1
end

function dynamic_body.getdirection (dirname)
  return dynamic_body.DIRECTION[dirname] * 1
end

return dynamic_body
