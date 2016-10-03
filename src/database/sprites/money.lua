
local money = {}

money[1]  = love.graphics.newImage('assets/images/objects.png')
local w, h = money[1]:getDimensions()

money[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
money[3]  = 0
money[4]  = 0
money[5]  = 0
money[6]  = 1
money[7]  = 1
money[8]  = 16
money[9]  = 20

money.animations = {
  default = {
    default = true,
    quads = {
      love.graphics.newQuad(13*32, 0, 32, 32, w, h),
    },
    step = 1
  },
}

return money
