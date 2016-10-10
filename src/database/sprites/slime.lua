
local slime = {}

slime[1]  = love.graphics.newImage('assets/images/slime.png')
local w, h = slime[1]:getDimensions()

slime[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
slime[3]  = 0
slime[4]  = 0
slime[5]  = 0
slime[6]  = 1
slime[7]  = 1
slime[8]  = 32
slime[9]  = 80

slime.animations = {
  default = {
    default = true,
    frames = {
      { love.graphics.newQuad(1*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(0*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(2*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(0*64, 0, 64, 96, w, h), { 32, 80 } },
    },
    step = 0.15
  },
}

return slime
