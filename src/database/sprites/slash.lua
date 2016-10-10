
local slash = {}

slash[1]  = love.graphics.newImage('assets/images/slash_v2.png')
local w, h = slash[1]:getDimensions()

slash[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
slash[3]  = 0
slash[4]  = 0
slash[5]  = 0
slash[6]  = -1
slash[7]  = 1

slash.animations = {
  default = {
    default = true,
    oneshot = true,
    frames = {
      { love.graphics.newQuad(0*96, 0, 96, 112, w, h), { 48, 56 } },
      { love.graphics.newQuad(1*96, 0, 96, 112, w, h), { 48, 56 } },
      { love.graphics.newQuad(2*96, 0, 96, 112, w, h), { 48, 56 } },
      { love.graphics.newQuad(3*96, 0, 96, 112, w, h), { 48, 56 } },
      { love.graphics.newQuad(4*96, 0, 96, 112, w, h), { 48, 56 } },
    },
    step = .04
  },
}

return slash
