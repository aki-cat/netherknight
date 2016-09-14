
local globals = require 'globals'
local class = orangelua.pack 'class'

local defaultquad = { 0, 0, globals.unit, globals.unit, globals.unit, globals.unit }

local animation = class.object:new {
  default = false,
  quads = { love.graphics.newQuad(unpack(defaultquad)) },
  step = 0.15,
  __type = 'animation'
}

function animation:__init ()
  self.playing = false
  self.timer = hump.timer.new()
  self.qid = 1
  self.current = self.quads[self.qid]
end

function animation:next ()
  self.qid = (self.qid % #self.quads) + 1
end

function animation:play ()
  self.timer:every(self.step, function() self:next() end)
end

function animation:stop ()
  self.timer.clear()
end

function animation:__update ()
  self.current = self.quads[self.qid]
  self.timer:update()
end

return animation
