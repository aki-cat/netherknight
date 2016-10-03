
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
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  local x, y = self.pos:unpack()
  local currenthp = self.maxhp - self.damage
  local maxhp = self.maxhp
  local red = 255 - 255 / (maxhp / currenthp)
  local green = 255 * currenthp / maxhp
  color:setRGBA(0, 0, 0, 255)
  love.graphics.rectangle(
    'fill',
    globals.unit * (x - .5),
    globals.unit * (y + self.size.y / 2 + 1/32),
    globals.unit * (1),
    globals.unit * 1/16
  )
  color:setRGBA(red, green, 150, 200)
  love.graphics.rectangle(
    'fill',
    globals.unit * (x - .5),
    globals.unit * (y + self.size.y / 2 + 1/32),
    globals.unit * (currenthp / maxhp),
    globals.unit * 1/16
  )
  color:reset()
  if self.name then
    love.graphics.printf(
      self.name,
      globals.unit * (x - 2),
      globals.unit * (y + self.size.y / 2 + 1/32),
      globals.unit * 4,
      'center'
    )
  end
  color:setRGBA(255, 255, 255, 100)
  love.graphics.rectangle(
    'fill',
    globals.unit * (x - self.size.x / 2),
    globals.unit * (y - self.size.y / 2),
    globals.unit * self.size.x,
    globals.unit * self.size.y
  )
  love.graphics.pop()
end

return entity
