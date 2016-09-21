
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
  audio:playSFX('Hurt')
  self.damage = self.damage + dmg
  self:stagger(globals.stagger)
  self:repulse(dir)
end

function entity:stagger (time)
  self.invincible = true
  self.timer:after(time, function() self.invincible = false end)
  hump.signal.emit('entity_immunity', self, true)
end

function entity:on_death ()
  -- implement on instance
end

function entity:die ()
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
end

return entity
