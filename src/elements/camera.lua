
local camera = require 'element' :new {
  __type = 'camera'
}

local vector = require 'basic.vector'

function camera:__init()
  self.target = false
  self.pos = vector:new {}
  self.width = globals.width * globals.unit
  self.height = globals.height * globals.unit
  self.offset = vector:new { self.width, self.height } / 2
  self.limits = {}
  self:set_limits(- globals.width / 2, - globals.height / 2, globals.width * 3 / 2, globals.height * 3 / 2)
end

function camera:set_limits (x, y, w, h)
  self.limits.top = y * globals.unit
  self.limits.left = x * globals.unit
  self.limits.right = w * globals.unit - self.width
  self.limits.bottom = h * globals.unit - self.height
end

function camera:set_target (pos)
  self.target = pos * globals.unit
end

function camera:checklimits ()
  self.pos.x = math.min(math.max(self.pos.x, self.limits.left), self.limits.right)
  self.pos.y = math.min(math.max(self.pos.y, self.limits.top), self.limits.bottom)
end

function camera:update()
  if self.target then
    self.pos = self.target - self.offset
    self:checklimits()
  end
end

function camera:draw()
  if self.target then
    local translation = self.pos * -1
    translation:set(math.floor(.5 + translation.x), math.floor(.5 + translation.y))
    love.graphics.translate((translation):unpack())
  end
end

return camera
