
-- libs
orangelua = require 'lib.orangelua.pack' 'lib.orangelua'
hump = orangelua.pack 'lib.hump'

-- modules
local globals = require 'globals'
local class = orangelua.pack 'class'
local gamestate = orangelua.pack 'gamestate'
local resource = orangelua.pack 'resource'
local modules = orangelua.pack 'modules'

-- local
local framedelay = 0

-- game_id
local game_id = {}

function love.load ()
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
    -- update modules
    modules.input:update()
    hump.gamestate.update()
  end
end

function love.draw ()
  hump.gamestate.draw()
end

function love.keypressed (key)
  modules.input:checkpress(key)
end

function love.keyreleased (key)
  modules.input:checkrelease(key)
end
