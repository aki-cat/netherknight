
local drumstick = {}

drumstick[1]  = love.graphics.newImage('assets/images/drumstick.png')
local w, h = drumstick[1]:getDimensions()

drumstick[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
drumstick[3]  = 0
drumstick[4]  = 0
drumstick[5]  = 0
drumstick[6]  = 1 / globals.unit
drumstick[7]  = 1 / globals.unit
drumstick[8]  = w / 2
drumstick[9]  = 3 * h / 5

drumstick.animations = {
  default = {
    default = true,
    quads = { drumstick[2] },
    step = 1
  },
}

return drumstick
