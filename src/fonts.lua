
local fonts = basic.prototype:new {
  __type = 'fonts'
}

function fonts:__init ()
  self.fonts = {}
  self.fonts[1] = love.graphics.newFont('assets/fonts/PressStart2P.ttf', 12)
  self.fonts[2] = love.graphics.newFont('assets/fonts/PressStart2P.ttf', 16)
  self.fonts[3] = love.graphics.newFont('assets/fonts/PressStart2P.ttf', 24)
  self.fonts[4] = love.graphics.newFont('assets/fonts/PressStart2P.ttf', 32)
end

function fonts:set (id)
  love.graphics.setFont(self.fonts[id])
end

return fonts:new {}
