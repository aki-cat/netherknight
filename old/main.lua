
-- libs
basic       = require 'basic.pack' 'basic'
physics     = basic.pack 'basic.physics'
module      = basic.pack ''
hump        = basic.pack 'lib.hump'
controllers = basic.pack 'controller'

globals     = module.globals
gamedata    = module.gamedata
audio       = module.audio
fonts       = module.fonts
color       = module.color
delta       = 0
frameid     = {}

-- modules
local input = require 'input'
local gamestate = basic.pack 'gamestate'

-- local
local framedelay = 0
local fps_update = require 'fps' :new {}
local fps_draw = require 'fps' :new {}

-- game_id
local game_id = tostring({}):sub(-7)

local function save_game ()
  love.filesystem.createDirectory('.')
  local savepath = love.filesystem.getSaveDirectory() .. '/.save_' .. gamedata.name .. '_' .. game_id
  local savedata = basic.io.serialise_table(gamedata)
  basic.io.write(savepath, savedata)
end

local function load_game (id)
  local loadpath = love.filesystem.getSaveDirectory() .. '/.save_' .. gamedata.name .. '_' .. id
  if love.filesystem.exists(savepath) then
    gamedata = require(loadpath)
    game_id = id
  end
end

local function delete_game ()
  local savepath = love.filesystem.getSaveDirectory() .. '/.save_' .. gamedata.name .. '_' .. game_id
  if love.filesystem.exists(savepath) then love.filesystem.remove(savepath) end
end

function love.load ()
  -- set save/load/write directory
  love.filesystem.setIdentity('everknight2', true)

  -- set random seed
  local seed = os.time()
  love.math.setRandomSeed(seed)
  print("SEED: " .. tostring(seed))

  -- overwrite lua's math.random with love's math.random
  math.random = love.math.random

  -- set quit and debug signals
  basic.signal:register(
    'save_game',
    function()
      save_game()
      basic.signal:emit('quit_game')
    end
  )
  basic.signal:register(
    'gameover',
    function()
      delete_game()
      basic.signal:emit('quit_game')
    end
  )
  basic.signal:register(
    'quit_game',
    function()
      print "QUIT GAME"
      love.event.quit()
    end
  )

  -- set default filter drawing mode
  love.graphics.setDefaultFilter('nearest', 'nearest', 5)


  -- set timer framerate
  basic.timer:setfps(globals.framerate)


  -- set current gamestate
  hump.gamestate.switch(gamestate.dungeon)
end

function love.update (dt)
  delta = dt
  framedelay = framedelay + dt

  fps_update:update(delta)
  fps_update:tick()
  while framedelay >= globals.frameunit do
    framedelay = framedelay - globals.frameunit
    frameid = nil
    frameid = {}

    -- update modules
    input:update()
    basic.timer:update()
    hump.gamestate.update()
  end
end

function love.draw ()
  fps_draw:update(delta)
  fps_draw:tick()
  hump.gamestate.draw()
  fonts:set(1)
  love.graphics.printf('LOGIC FPS: ' .. tostring(fps_update.fps), 32, 32, 640-64, 'left')
  love.graphics.printf('RENDER FPS: ' .. tostring(fps_draw.fps), 32, 48, 640-64, 'left')
end

function love.keypressed (key)
  input:checkpress(key)
end

function love.keyreleased (key)
  input:checkrelease(key)
end
