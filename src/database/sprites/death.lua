
local death = {}

death[1]  = love.graphics.newImage('assets/images/death.png')
local w, h = death[1]:getDimensions()
death[1]:setFilter('linear', 'linear')

death[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
death[3]  = 0
death[4]  = 0
death[5]  = 0
death[6]  = 2 / globals.unit
death[7]  = 2 / globals.unit
death[8]  = 32
death[9]  = 32

death.animations = {
  default = {
    oneshot = true,
    default = true,
    quads = {
      love.graphics.newQuad(00*64, 0, 64, 64, w, h),
      love.graphics.newQuad(01*64, 0, 64, 64, w, h),
      love.graphics.newQuad(02*64, 0, 64, 64, w, h),
      love.graphics.newQuad(03*64, 0, 64, 64, w, h),
      love.graphics.newQuad(04*64, 0, 64, 64, w, h),
      love.graphics.newQuad(05*64, 0, 64, 64, w, h),
      love.graphics.newQuad(06*64, 0, 64, 64, w, h),
      love.graphics.newQuad(07*64, 0, 64, 64, w, h),
      love.graphics.newQuad(08*64, 0, 64, 64, w, h),
    },
    step = 0.0666
  },
}

return death
