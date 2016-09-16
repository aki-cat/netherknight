
local player = physics.dynamic_body:new {
  __type = 'player'
}

function player:__init ()
  self.locked = false
end

function player:repulse (point)
  local antigravity = self.pos - point
  local distsqr = antigravity * antigravity
  self:move(0.04 * antigravity:normalized() / distsqr)
end

function player:on_collision (somebody)
  if somebody:get_type() == 'collision_body' then
    self:stop()
  elseif somebody:get_type() == 'dynamic_body' then
    self:repulse(somebody.pos)
  elseif somebody:get_type() == 'monster' then
    self:take_damage(somebody.attack)
    self:repulse(somebody.pos)
  end
end

function player:draw ()
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  love.graphics.printf(
    "HP: " .. tostring(self.maxhp - self.damage) .. "/" .. tostring(self.maxhp),
    globals.unit * (self.pos.x - self.size.x), globals.unit * ((self.pos.y - self.size.y) + 0.5),
    globals.unit * self.size.x * 2,
    "center"
  )
  love.graphics.pop()
end

function player:lock (time)
  self.timer:after(time, function() self:unlock() end)
  self.locked = true
end

function player:unlock ()
  self.locked = false
end

return player
