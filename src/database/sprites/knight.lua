
local knight = {}

knight[1]  = love.graphics.newImage('assets/images/knight-preliminary.png')
local w, h = knight[1]:getDimensions()

knight[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
knight[3]  = 0
knight[4]  = 0
knight[5]  = 0
knight[6]  = 1 / globals.unit
knight[7]  = 1 / globals.unit
knight[8]  = 32
knight[9]  = 72

knight.animations = {
  default = {
    default = true,
    quads = {
      love.graphics.newQuad(0*64, 0, 64, 96, w, h),
      love.graphics.newQuad(1*64, 0, 64, 96, w, h),
      love.graphics.newQuad(2*64, 0, 64, 96, w, h),
      love.graphics.newQuad(1*64, 0, 64, 96, w, h),
    },
    step = 0.15
  },
  walking = {
    default = false,
    quads = {
      love.graphics.newQuad(3*64, 0, 64, 96, w, h),
      love.graphics.newQuad(4*64, 0, 64, 96, w, h),
      love.graphics.newQuad(5*64, 0, 64, 96, w, h),
      love.graphics.newQuad(6*64, 0, 64, 96, w, h),
    },
    step = 0.15
  },
}

return knight
