
local globals = {}

local w, h = love.window.getMode()
globals.unit = 64
globals.width = w / globals.unit
globals.height = h / globals.unit
globals.framerate = 60
globals.frameunit = 1 / globals.framerate
globals.epsilon = 5e-9
globals.stagger = 0.5

return globals
