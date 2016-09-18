
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
  self.maxhp = 10
  self.damage = 0
  self.timer = hump.timer.new()
  self.speed = basic.vector:new {}
  self.dir = 'down'
end

function dynamic_body:update ()
  self.timer:update(delta)
  self:deaccelerate()
  self.pos:add(self.speed)
  if self.think and type(self.think) == 'function' then self:think() end
  if self.damage >= self.maxhp then self:die() end
end

function dynamic_body:draw ()
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  love.graphics.printf(
    "HP: " .. tostring(self.maxhp - self.damage) .. "/" .. tostring(self.maxhp),
    globals.unit * (self.pos.x - self.size.x), globals.unit * ((self.pos.y - self.size.y) + 0.5),
    globals.unit * self.size.x * 2,
    "center"
  )
  love.graphics.pop()
  if self.statusdraw and type(self.statusdraw) == 'function' then self:statusdraw() end
end

function dynamic_body:repulse (point)
  if self.invincible then return end
  local antigravity = self.pos - point
  local distsqr = antigravity * antigravity
  self:move(0.04 * antigravity:normalized() / distsqr)
end

function dynamic_body:take_damage (dmg)
  if self.invincible then return end
  self.damage = self.damage + dmg
end

function dynamic_body:stagger (time)
  self.invincible = true
  self.timer:after(time, function() self.invincible = false end)
end

function dynamic_body:die ()
  hump.signal.emit('body_death', self)
end

function dynamic_body:on_collision (somebody)
  if somebody:get_type() == 'collision_body' then
    self:stop()
  end
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
