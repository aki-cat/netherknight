
local slime = {}

slime[1]  = love.graphics.newImage('assets/images/slime.png')
local w, h = slime[1]:getDimensions()

slime[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
slime[3]  = 0
slime[4]  = 0
slime[5]  = 0
slime[6]  = 1 / globals.unit
slime[7]  = 1 / globals.unit
slime[8]  = 32
slime[9]  = 80

slime.animations = {
  default = {
    default = true,
    quads = {
      love.graphics.newQuad(1*64, 0, 64, 96, w, h),
      love.graphics.newQuad(0*64, 0, 64, 96, w, h),
      love.graphics.newQuad(2*64, 0, 64, 96, w, h),
      love.graphics.newQuad(0*64, 0, 64, 96, w, h),
    },
    step = 0.2
  },
}

return slime
