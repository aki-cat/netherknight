
local eye = {}

eye[1]  = love.graphics.newImage('assets/images/eye.png')
local w, h = eye[1]:getDimensions()

eye[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
eye[3]  = 0
eye[4]  = 0
eye[5]  = 0
eye[6]  = 1
eye[7]  = 1

eye.animations = {
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

return eye
