
local sprites = basic.pack 'database.sprites'
local color = require 'color'

local sprite = basic.prototype:new {
  sprites.dummy,
  __type = 'sprite'
}

function sprite:__init ()
  local resource = self[1]
  self.pos = basic.vector:new { resource[3], resource[4] }
  self.offset = basic.vector:new { resource[8], resource[9] }
  self.scale = (resource[6] + resource[7]) / 2
  self.rotation = 0
  self.fliph = false
  self.flipv = false
  self.animations = resource.animations
  self.state = 'default'
  self.drawable = {}
  self.qid = 1
  self.brightness = 0
  self.timer = hump.timer.new()
  for i,attr in ipairs(resource) do self.drawable[i] = attr end
end

function sprite:setquad (i)
  self.qid = i
end

function sprite:getquad ()
  return self.animations[self.state].quads[self.qid]
end

function sprite:setflip (axis, enable)
  if     axis == 'h' then self.fliph = enable
  elseif axis == 'v' then self.flipv = enable end
end

function sprite:setscale (s)
  self.scale = s
end

function sprite:setrotation (r)
  self.rotation = r
end

function sprite:shine (time)
  local shinelevel = 100
  local step = shinelevel/time
  self.timer:during(
    time,
    function()
      shinelevel = shinelevel - step * delta
      self.brightness = shinelevel
    end,
    function()
      self.brightness = 0
    end
  )
end

function sprite:update ()
  self.timer:update(delta)
  self.drawable[2] = self:getquad()
  self.drawable[3], self.drawable[4] = self.pos:unpack()
  self.drawable[5] = self.rotation
  self.drawable[6] = self.fliph and -self.scale or self.scale
  self.drawable[7] = self.flipv and -self.scale or self.scale
  self.drawable[8], self.drawable[9] = self.offset.x, self.offset.y
end

function sprite:draw ()
  -- set color effects
  love.graphics.setColor(color.HSL(0, 0, 255 + self.brightness * 80))

  love.graphics.draw(unpack(self.drawable))

  -- reset effects
  love.graphics.setColor(255,255,255)
end

return sprite
