
local dungeon = {}
local controllers = basic.pack 'controller.dungeon'

function dungeon:init ()
  -- print every controller so they are loaded by pack
  print(controllers.player)
  print(controllers.entities)
  print(controllers.rooms)
  print(controllers.sprites)
end

local function load_player()
  local player_body = require 'player' :new { globals.width / 2, globals.height / 2, 1/2, 1/4 }
  local player_sprite = require 'sprite' :new { sprites.slime }
  hump.signal.emit('add_entity', player_body)
  hump.signal.emit('add_sprite', player_sprite)
end

function dungeon:enter ()
  for k, control in pairs(controllers) do
    control:connect()
  end
  load_player()
end

function dungeon:update ()
end

function dungeon:draw ()
end

function dungeon:leave ()
end

function dungeon:getentity (name)
  return controllers.entities:get(name)
end

return dungeon
