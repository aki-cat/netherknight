
-- libs
sol = require 'lib.sol.pack' 'lib.sol'
hump = pack 'lib.hump'

-- modules
local globals = require 'globals'
local fixedframe = require "fixedframe"
local class = pack 'class'
local gamestate = pack 'gamestate'
local resource = pack 'resource'

function love.load ()
  hump.gamestate.switch(gamestate.game)
end

function love.update (dt)
  fixedframe.update(dt)
end

function love.draw ()
end
