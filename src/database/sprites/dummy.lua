
local dummy = {}

dummy[1]  = love.graphics.newImage('assets/images/dummy.png')
local w, h = dummy[1]:getDimensions()

dummy[2]  = love.graphics.newQuad(0, 0, w, h, w, h)
dummy[3]  = 0
dummy[4]  = 0
dummy[5]  = 0
dummy[6]  = 1 / globals.unit
dummy[7]  = 1 / globals.unit
dummy[8]  = w / 2
dummy[9]  = h / 2

dummy.animations = {}

return dummy
