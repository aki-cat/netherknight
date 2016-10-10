
local knight = {}

knight[1]  = love.graphics.newImage('assets/images/knight-preliminary.png')
local w, h = knight[1]:getDimensions()

knight[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
knight[3]  = 0
knight[4]  = 0
knight[5]  = 0
knight[6]  = 1
knight[7]  = 1

knight.animations = {
  default = {
    default = true,
    frames = {
      { love.graphics.newQuad(0*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(1*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(2*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(1*64, 0, 64, 96, w, h), { 32, 80 } },
    },
    step = 0.15
  },
  walking = {
    default = false,
    frames = {
      { love.graphics.newQuad(3*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(4*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(5*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(6*64, 0, 64, 96, w, h), { 32, 80 } },
    },
    step = 0.15
  },
  attack = {
    default = false,
    oneshot = true,
    frames = {
      { love.graphics.newQuad(7*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(7*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(8*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(8*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(9*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(9*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(10*64, 0, 64, 96, w, h), { 32, 80 } },
      { love.graphics.newQuad(10*64, 0, 64, 96, w, h), { 32, 80 } },
    },
    step = 0.0333
  }
}

return knight
