
local death = {}

death[1]  = love.graphics.newImage('assets/images/death.png')
local w, h = death[1]:getDimensions()

death[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
death[3]  = 0
death[4]  = 0
death[5]  = 0
death[6]  = 1 / globals.unit
death[7]  = 1 / globals.unit
death[8]  = 64
death[9]  = 64

death.animations = {
  default = {
    oneshot = true,
    default = true,
    quads = {
      love.graphics.newQuad(00*128, 0, 128, 128, w, h),
      love.graphics.newQuad(01*128, 0, 128, 128, w, h),
      love.graphics.newQuad(02*128, 0, 128, 128, w, h),
      love.graphics.newQuad(03*128, 0, 128, 128, w, h),
      love.graphics.newQuad(04*128, 0, 128, 128, w, h),
      love.graphics.newQuad(05*128, 0, 128, 128, w, h),
      love.graphics.newQuad(06*128, 0, 128, 128, w, h),
      love.graphics.newQuad(07*128, 0, 128, 128, w, h),
      love.graphics.newQuad(08*128, 0, 128, 128, w, h),
      love.graphics.newQuad(09*128, 0, 128, 128, w, h),
      love.graphics.newQuad(10*128, 0, 128, 128, w, h),
      love.graphics.newQuad(11*128, 0, 128, 128, w, h),
    },
    step = 0.050
  },
}

return death
