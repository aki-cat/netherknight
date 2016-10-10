
local slash = {}

slash[1]  = love.graphics.newImage('assets/images/slash.png')
local w, h = slash[1]:getDimensions()

slash[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
slash[3]  = 0
slash[4]  = 0
slash[5]  = 0
slash[6]  = -2
slash[7]  = 3

slash.animations = {
  default = {
    default = true,
    frames = {
      { love.graphics.newQuad(0*64, 0, 64, 64, w, h), { 48, 32 } }
    },
    step = 1
  },
}

return slash
