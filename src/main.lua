
-- libs
globals     = require 'globals'
basic       = require 'lib.basic.pack' 'lib.basic'
gamedata    = require 'gamedata'
audio       = require 'audio'
hump        = basic.pack 'lib.hump'
controllers = basic.pack 'controller'
physics     = basic.pack 'physics'
delta       = 0
frameid     = {}

-- modules
local input = require 'input'
local gamestate = basic.pack 'gamestate'

-- local
local framedelay = 0
local fps_update = require 'fps' :new {}
local fps_draw = require 'fps' :new {}
local debug_prints = {}

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
  math.randomseed(seed)
  print("SEED: " .. tostring(seed))

  -- set quit and debug signals
  hump.signal.register(
    'presskey',
    function(action)
      if action == 'quit' then
        save_game()
        hump.signal.emit('quit_game')
      end
    end
  )
  hump.signal.register(
    'gameover',
    function()
      delete_game()
      hump.signal.emit('quit_game')
    end
  )
  hump.signal.register(
    'quit_game',
    function()
      print "QUIT GAME"
      love.event.quit()
    end
  )
  hump.signal.register(
    'debug_print',
    function(text)
      assert(type(text) == 'table', "Debug print must be a table with string and alpha!")
      table.insert(debug_prints, text)
    end
  )

  -- set current gamestate
  hump.gamestate.switch(gamestate.dungeon)
end

function love.update (dt)
  delta = dt
  framedelay = framedelay + dt

  fps_update:update(delta)
  while framedelay >= globals.frameunit do
    framedelay = framedelay - globals.frameunit
    frameid = nil
    frameid = {}

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
  local i = -1
  for debugger, text in pairs(debug_prints) do
    i = i + 1
    love.graphics.setColor(255, 255, 255, text.alpha or 255)
    love.graphics.printf(text.string or 'debug!', 0, 240 + i * globals.unit / 2, 1024, 'center')
    love.graphics.setColor(255, 255, 255, 255)
    debug_prints[debugger] = nil
  end
end

function love.keypressed (key)
  input:checkpress(key)
end

function love.keyreleased (key)
  input:checkrelease(key)
end
