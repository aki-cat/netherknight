
local controllers = basic.pack 'controller.dungeon'
local sprites = basic.pack 'database.sprites'

local dungeon = {}
local camera = require 'camera' :new {}

local player_entity = require 'player' :new { globals.width / 2, globals.height / 2, 1/5 }
local player_sprite = require 'sprite' :new { sprites.slime }

function dungeon:init ()
end

local function load_player ()
  print("loading player...")
  player_entity.damage = 0
  hump.signal.emit('add_entity', 'player', player_entity)
  hump.signal.emit('add_sprite', 'player', player_sprite)
end

local function unload_player ()
  hump.signal.emit('remove_entity', player_entity)
  hump.signal.emit('remove_sprite', player_sprite)
end

function dungeon:enter ()
  -- connect every controller so they are loaded by pack
  controllers.player:connect()
  controllers.entities:connect()
  controllers.rooms:connect()
  controllers.sprites:connect()
  -- load room and player
  controllers.rooms:goto_room(1)
  load_player()
  camera:set_target(player_entity)
end

function dungeon:update ()
  controllers.player:update()
  controllers.entities:update()
  controllers.rooms:update()
  controllers.sprites:update()
  camera:update()
end

function dungeon:draw ()
  love.graphics.push()
  love.graphics.scale(globals.unit)
  camera:draw()
  controllers.player:draw()
  controllers.rooms:draw()
  controllers.entities:draw()
  controllers.sprites:draw()
  love.graphics.pop()
end

function dungeon:leave ()
  controllers.player:disconnect()
  controllers.entities:disconnect()
  controllers.rooms:disconnect()
  controllers.sprites:disconnect()
  unload_player()
end

function dungeon:getentity (name)
  return controllers.entities:get(name)
end

return dungeon
