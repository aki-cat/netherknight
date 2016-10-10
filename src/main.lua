
-- lua version fix
require 'basic.tableutility'

-- globals
globals = require 'globals'
unique_id = require 'basic.unique'
signal = require 'signal'
timer = require 'basic.timer' :new { globals.framerate }

-- input handler
local input = require 'utility.input'

-- fps counters (debug only)
local logic_fps = require 'utility.fps':new {}
local render_fps = require 'utility.fps':new {}

-- frame constants
local framedelay = 0
local framerate = globals.framerate
local frameunit = globals.frameunit

-- game stuff
local gamestate = require 'gamestate'
local sfx = require 'controllers.audio.sfx'


-- [[ LOAD BASICS ]]

function love.load ()
  -- random fix
  math.randomseed = love.math.setRandomSeed
  math.random = love.math.random
  math.randomseed(os.time())

  -- set default filter drawing mode
  love.graphics.setDefaultFilter('nearest', 'nearest', 5)

  -- tests first
  -- require 'tests'

  -- initialise sound
  signal.connect(sfx)


  -- set current gamestate
  local gameplay = require 'gamestates.gameplay'
  gamestate.load(gameplay)
end


-- [[ UPDATE LOGIC ]]

function love.update (dt)
  -- get update delta time
  delta = dt
  framedelay = framedelay + dt

  -- update logic fps
  logic_fps:update(delta)
  logic_fps:tick()

  while framedelay >= frameunit do
    -- fixing delay to match framerate
    framedelay = framedelay - frameunit

    -- FRAME ID (uncomment to check for infinite loop)
    -- print('CURRENT FRAME: ' .. tostring({}):sub(-7))

    -- update modules
    input:update()
    gamestate.update()
    timer:update()
    sfx:update()
  end
end


-- [[ RENDER VISUALS ]]

function love.draw ()
  -- update render fps
  render_fps:update(delta)
  render_fps:tick()

  -- draw current gamestate
  gamestate.draw()

  -- draw debug fps
  love.graphics.printf('LOGIC FPS: ' .. tostring(logic_fps.fps), 32, 32, 640-64, 'left')
  love.graphics.printf('RENDER FPS: ' .. tostring(render_fps.fps), 32, 48, 640-64, 'left')
end

function love.keypressed (key)
  input:checkpress(key)
end

function love.keyreleased (key)
  input:checkrelease(key)
end
