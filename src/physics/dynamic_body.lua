
local dynamic_body = physics.collision_area:new {
  centred = true,
  direction = {
    right      = basic.vector:new { math.cos(math.pi * 0/4), math.sin(math.pi * 0/4), },
    down_right = basic.vector:new { math.cos(math.pi * 1/4), math.sin(math.pi * 1/4), },
    down       = basic.vector:new { math.cos(math.pi * 2/4), math.sin(math.pi * 2/4), },
    down_left  = basic.vector:new { math.cos(math.pi * 3/4), math.sin(math.pi * 3/4), },
    left       = basic.vector:new { math.cos(math.pi * 4/4), math.sin(math.pi * 4/4), },
    up_left    = basic.vector:new { math.cos(math.pi * 5/4), math.sin(math.pi * 5/4), },
    up         = basic.vector:new { math.cos(math.pi * 6/4), math.sin(math.pi * 6/4), },
    up_right   = basic.vector:new { math.cos(math.pi * 7/4), math.sin(math.pi * 7/4), },
  },
  __type = 'dynamic_body'
}

function dynamic_body:__newindex (k, v)
  if k == 'direction' then return error "Don't change class static values!"
  else rawset(self, k, v) end
end

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
  self:face(acc)
end

function dynamic_body:stop (h, v)
  self.pos:sub(self.speed)
  if h then self.speed.x = 0 end
  if v then self.speed.y = 0 end
  self.pos:add(self.speed)
end

function dynamic_body:deaccelerate ()
  self.speed:mul(0.8)
  if self.speed * self.speed < globals.epsilon then
    self.speed:set(0, 0)
  end
end

function dynamic_body:face(dir)
  if type(dir) == 'string' then
    self.dir = dir
  else
    -- assume it's a vector
    local angle = math.atan2(dir.y, dir.x)
    local pi = math.pi
    if angle >= 0 then
      if     angle <= 1 * pi / 8 then self.dir = 'right'
      elseif angle <= 3 * pi / 8 then self.dir = 'down_right'
      elseif angle <= 5 * pi / 8 then self.dir = 'down'
      elseif angle <= 7 * pi / 8 then self.dir = 'down_left'
      else self.dir = 'left' end
    else
      if     angle >= -1 * pi / 8 then self.dir = 'right'
      elseif angle >= -3 * pi / 8 then self.dir = 'up_right'
      elseif angle >= -5 * pi / 8 then self.dir = 'up'
      elseif angle >= -7 * pi / 8 then self.dir = 'up_left'
      else self.dir = 'left' end
    end
  end
end

function dynamic_body:getdirection ()
  return self.direction[self.dir] * 1
end

function dynamic_body:check_collision_by_axis (somebody)
  local speedx, speedy = self.speed * 1, self.speed * 1
  speedx.y, speedy.x = 0, 0

  local posh, posv = self.pos + speedx, self.pos + speedy
  local bodyh = { pos = posh, size = self.size, centred = self.centred }
  local bodyv = { pos = posv, size = self.size, centred = self.centred }

  local h, v = self.rectangle_collision(bodyh, somebody), self.rectangle_collision(bodyv, somebody)
  local actor_self, actor_other = self:layer_collision(somebody)

  if h or v then
    if actor_self then self:on_collision(somebody, h, v) end
    if actor_other then somebody:on_collision(self, h, v) end
  end
end

function dynamic_body:on_collision (somebody, h, v)
  self:stop(h, v)
end

return dynamic_body
