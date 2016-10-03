
local entity = physics.dynamic_body :new {
  name = 'Entity',
  __type = 'entity'
}

function entity:__init ()
  self.maxhp = 1
  self.damage = 0
  self.timer = basic.timer:new {}
  self.dead = false
end

function entity:take_damage (dmg, frompos)
  if self.invincible then return end
  basic.signal:emit('take_damage', self, dmg)
  self.damage = math.min(self.damage + dmg, self.maxhp)
  self:stagger(globals.stagger)
  self:repulse(frompos)
end

function entity:stagger (time)
  self.invincible = true
  self.timer:after(time, function() self.invincible = false end)
  basic.signal:emit('entity_immunity', self, time)
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
  basic.signal:emit('entity_turn', self, self.dir)
  self.timer:update()
  if self:isdead() then self:die() end
end

function entity:draw ()
  local x, y = (self.pos * globals.unit):unpack()
  local w, h = (self.size * globals.unit):unpack()
  local currenthp = self.maxhp - self.damage
  local maxhp = self.maxhp
  local percentagehp = currenthp / maxhp
  local red = 255 - 255 / (1 / percentagehp)
  local green = 255 * percentagehp
  color:setRGBA(0, 0, 0, 255)
  love.graphics.rectangle('fill', x - 32, y + h / 2 + 2, globals.unit, 4)
  color:setRGBA(red, green, 150, 200)
  love.graphics.rectangle('fill', x - 32, y + h / 2 + 2, globals.unit * percentagehp, 4)
  if self.name then
    color:reset()
    love.graphics.printf(self.name, x - 256, y + h / 2 + 2, 256 * 2, 'center')
  end
  color:setRGBA(255, 255, 255, 100)
  --love.graphics.rectangle('fill', x - w / 2, y - h / 2, w, h )
  color:reset()
end

return entity
