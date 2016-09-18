
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
local fps_update = require 'fps' :new {}
local fps_draw = require 'fps' :new {}

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
  delta = dt
  framedelay = framedelay + dt

  fps_update:update(delta)
  while framedelay >= globals.frameunit do
    framedelay = framedelay - globals.frameunit

    -- update modules
    fps_update:tick()
    input:update()
    hump.timer.update(dt)
    hump.gamestate.update()
  end
end

function love.draw ()
  fps_draw:update(delta)
  fps_draw:tick()
  hump.gamestate.draw()
  love.graphics.printf('LOGIC FPS: ' .. tostring(fps_update.fps), 32, 32, 640-64, 'left')
  love.graphics.printf('RENDER FPS: ' .. tostring(fps_draw.fps), 32, 48, 640-64, 'left')
end

function love.keypressed (key)
  input:checkpress(key)
end

function love.keyreleased (key)
  input:checkrelease(key)
end
