
local sprites = basic.pack 'database.sprites'

local sprite = basic.prototype:new {
  sprites.dummy,
  __type = 'sprite'
}

function sprite:__init ()
  local resource = self[1]
  self.pos = basic.vector:new { -8000, -8000 }
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
  self.alpha = 255
  self.timer = hump.timer.new()
  for i,attr in ipairs(resource) do self.drawable[i] = attr end
  self:playanimation()
end

function sprite:playanimation ()
  local animation = self.animations[self.state]
  if animation.oneshot then
    self.timer:every(
      animation.step,
      function ()
        self.qid = self.qid + 1
      end,
      #animation.quads - 1
    )
  else
    self.timer:every(
      animation.step,
      function ()
        self.qid = self.qid % #animation.quads + 1
      end
    )
  end
end

function sprite:setanimation (animation)
  if self.state ~= animation and self.animations[animation] then
    self.state = animation
    self.qid = 1
    self.timer:clear()
    self:playanimation()
  end
end

function sprite:freezeanimation ()
  self.timer:clear()
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
  -- set color effect
  module.color:setHSLA(0, 0, 255 + self.brightness * 80, self.alpha)

  love.graphics.draw(unpack(self.drawable))

  module.color:reset()
end

return sprite
