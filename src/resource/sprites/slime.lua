
local class = orangelua.pack 'class'
local slime = {}

slime[1]  = love.graphics.newImage('assets/images/slime.png')
slime[2]  = false
slime[3]  = 0
slime[4]  = 0
slime[5]  = 0
slime[6]  = 1
slime[7]  = 1
slime[8]  = 32
slime[9]  = 80

slime.animation_info = {
  animations = {
    idle = class.animation:new {
      default = true,
      quads = {
        love.graphics.newQuad(0*64, 0, 64, 96, slime[1]:getDimensions()),
        love.graphics.newQuad(1*64, 0, 64, 96, slime[1]:getDimensions()),
        love.graphics.newQuad(2*64, 0, 64, 96, slime[1]:getDimensions()),
      },
      step = 0.2
    },
    moving = class.animation:new {
      quads = {
        love.graphics.newQuad(0*64, 0, 64, 96, slime[1]:getDimensions()),
        love.graphics.newQuad(1*64, 0, 64, 96, slime[1]:getDimensions()),
        love.graphics.newQuad(2*64, 0, 64, 96, slime[1]:getDimensions()),
      },
      step = 0.1
    },
  }
}

return slime
