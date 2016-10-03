
local fonts = basic.prototype:new {
  __type = 'fonts'
}

function fonts:__init ()
  self.fonts = {}
  self.fonts[1] = love.graphics.newFont('assets/fonts/MOZART_0.ttf', 20)
  self.fonts[2] = love.graphics.newFont('assets/fonts/MOZART_0.ttf', 32)
  self.fonts[3] = love.graphics.newFont('assets/fonts/MOZART_0.ttf', 48)
  self.fonts[4] = love.graphics.newFont('assets/fonts/MOZART_0.ttf', 48)
end

function fonts:set (id)
  love.graphics.setFont(self.fonts[id])
end

return fonts:new {}
