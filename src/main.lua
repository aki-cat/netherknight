
-- libs
globals =     require 'globals'
basic =       require 'lib.basic.pack' 'lib.basic'
hump =        basic.pack 'lib.hump'
controllers = basic.pack 'controller'
physics =     basic.pack 'physics'
delta = 0

-- modules
local input = require 'input'
local gamestate = basic.pack 'gamestate'

-- local
local framedelay = 0
local framecount = 0

-- game_id
local game_id = {}

function love.load ()
  math.randomseed(os.time())
  hump.signal.register(
    'presskey',
    function(action)
      if action == 'quit' then
        love.event.quit()
      end
    end)
  hump.gamestate.switch(gamestate.game)
end

function love.update (dt)
  framedelay = framedelay + dt
  while framedelay >= globals.frameunit do
    framedelay = framedelay - globals.frameunit
    framecount = framecount + 1
    -- update modules
    delta = dt
    input:update()
    hump.timer.update(dt)
    hump.gamestate.update()
  end
end

function love.draw ()
  hump.gamestate.draw()
end

function love.keypressed (key)
  input:checkpress(key)
end

function love.keyreleased (key)
  input:checkrelease(key)
end
