
local globals = require 'globals'

local defaultquad = { 0, 0, globals.unit, globals.unit, globals.unit, globals.unit }

local animation = class.object:new {
  default = false
  quads = { love.graphics.newQuad(unpack(defaultquad)) },
  step = 0.15,
  __type = 'animation'
}

function animation:__init ()
  self.playing = false
  self.timer = hump.timer.new()
  self.qid = 1
end

function animation:next ()
  self.qid = (self.qid % #self.quads) + 1
end

function animation:play ()
  self.timer.every(self.step, function() self:next() end)
end

function animation:stop ()
  self.timer.clear()
end

function animation:update ()
  self:__super().update(self)
  self.timer:update()
end

return animation
