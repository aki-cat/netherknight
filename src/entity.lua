
local entity = physics.dynamic_body :new {
  __type = 'entity'
}

function entity:__init ()
  self.maxhp = 1
  self.damage = 0
  self.timer = basic.timer.new(globals.framerate)
  self.dead = false
end

function entity:take_damage (dmg, frompos)
  if self.invincible then return end
  audio:playSFX('Hurt')
  module.notification:new { 'damage', self.pos.x, self.pos.y, value = dmg }
  self.damage = self.damage + dmg
  self:stagger(globals.stagger)
  self:repulse(frompos)
end

function entity:stagger (time)
  self.invincible = true
  self.timer:after(time, function() self.invincible = false end)
  hump.signal.emit('entity_immunity', self)
end

function entity:on_death ()
  -- implement on instance
end

function entity:die ()
  if self.dead then return end
  self.dead = true
  self:on_death()
end

function entity:isdead ()
  return self.maxhp <= self.damage
end

function entity:update ()
  physics.dynamic_body.update(self) -- call dynamic body update
  self.timer:update(delta)
  if self:isdead() then self:die() end
end

function entity:draw ()
  color:setRGBA(255,255,255,128)
  local x, y = (self.pos - self.size/2):unpack()
  --love.graphics.rectangle('fill', x, y, self.size.x, self.size.y)
  color:reset()
end

return entity
