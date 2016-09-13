
local globals = {}

globals.framerate = 60
globals.frameunit = 1/globals.framerate
globals.unit = 64
globals.width, globals.height = love.window.getMode()

return globals
