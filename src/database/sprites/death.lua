
local death = {}

death[1]  = love.graphics.newImage('assets/images/death.png')
local w, h = death[1]:getDimensions()

death[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
death[3]  = 0
death[4]  = 0
death[5]  = 0
death[6]  = 1
death[7]  = 1

death.animations = {
  default = {
    oneshot = true,
    default = true,
    frames = {
      { love.graphics.newQuad(00*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(01*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(02*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(03*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(04*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(05*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(06*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(07*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(08*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(09*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(10*128, 0, 128, 128, w, h), { 64, 64 } },
      { love.graphics.newQuad(11*128, 0, 128, 128, w, h), { 64, 64 } },
    },
    step = 0.05
  },
}

return death
