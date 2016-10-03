
local slash = {}

slash[1]  = love.graphics.newImage('assets/images/slash.png')
local w, h = slash[1]:getDimensions()

slash[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
slash[3]  = 0
slash[4]  = 0
slash[5]  = 0
slash[6]  = 1
slash[7]  = 2
slash[8]  = 48
slash[9]  = 32

slash.animations = {
  default = {
    default = true,
    quads = {
      love.graphics.newQuad(0*64, 0, 64, 64, w, h),
    },
    step = 0.1
  },
}

return slash
