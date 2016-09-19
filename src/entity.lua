
local entity = physics.dynamic_body :new {
  __type = 'entity'
}

function entity:__init ()
  self.maxhp = 1
  self.damage = 0
  self.timer = hump.timer.new()
end

function entity:take_damage (dmg, dir)
  if self.invincible then return end
  self.damage = self.damage + dmg
  self:stagger(globals.stagger)
  self:repulse(dir)
end

function entity:stagger (time)
  self.invincible = true
  hump.signal.emit('body_immunity', self, true)
  self.timer:after(time, function()
    self.invincible = false
    hump.signal.emit('body_immunity', self, false)
  end)
end

function entity:die ()
  hump.signal.emit('entity_death', self)
end

function entity:isdead ()
  return self.maxhp <= self.damage
end

function entity:update ()
  physics.dynamic_body.update(self) -- call dynamic body update
  self.timer:update(delta)
  if self.think and type(self.think) == 'function' then self:think() end
  if self:isdead() then self:die() end
end

function entity:draw ()
  print("drawing entity meta")
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  love.graphics.printf(
    "HP: " .. tostring(self.maxhp - self.damage) .. "/" .. tostring(self.maxhp),
    globals.unit * (self.pos.x - self.size.x),
    globals.unit * (self.pos.y - self.size.y/2 + 0.25),
    globals.unit * self.size.x * 2,
    "center"
  )
  love.graphics.pop()
end

return entity
