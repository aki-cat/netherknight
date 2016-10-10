
local drumstick = {}

drumstick[1]  = love.graphics.newImage('assets/images/drumstick.png')
local w, h = drumstick[1]:getDimensions()

drumstick[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
drumstick[3]  = 0
drumstick[4]  = 0
drumstick[5]  = 0
drumstick[6]  = 1
drumstick[7]  = 1

drumstick.animations = {}

return drumstick
