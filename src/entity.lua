
local entity = physics.dynamic_body :new {
  name = 'Entity',
  __type = 'entity'
}

function entity:__init ()
  self.maxhp = 1
  self.damage = 0
  self.timer = basic.timer:new {}
  self.dead = false
  self.dir = 'down'
  self:set_layer(2)
  self:set_mask(1)
  self:set_mask(2)
end

function entity:face (dir)
  self.dir = dir
end

function entity:update_face ()
  -- check if worth it
  local speed = self:get_speed()
  if speed * speed == 0 then return end

  local dir
  local angle = math.atan2(speed.y, speed.x)
  if angle >= 0 then
    if     angle <= 1 * math.pi / 8 then dir = 'right'
    elseif angle <= 3 * math.pi / 8 then dir = 'down_right'
    elseif angle <= 5 * math.pi / 8 then dir = 'down'
    elseif angle <= 7 * math.pi / 8 then dir = 'down_left'
    else dir = 'left' end
  else
    if     angle >= -1 * math.pi / 8 then dir = 'right'
    elseif angle >= -3 * math.pi / 8 then dir = 'up_right'
    elseif angle >= -5 * math.pi / 8 then dir = 'up'
    elseif angle >= -7 * math.pi / 8 then dir = 'up_left'
    else dir = 'left' end
  end
  self.dir = dir
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
  -- call dynamic body update
  physics.dynamic_body.update(self)

  -- update timers
  self.timer:update()

  if self:isdead() then
    self:die()
  else
    self:update_face()
    basic.signal:emit('entity_turn', self, self.dir)
  end
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
