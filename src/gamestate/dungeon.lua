
local controllers = basic.pack 'controller.dungeon'
local sprites = basic.pack 'database.sprites'

local dungeon = {}
local camera = require 'camera' :new {}

local player_entity = require 'player' :new { 0, 0, 1/2, 1/2 }
local player_sprite = require 'sprite' :new { sprites.knight }

function dungeon:init ()
end

local function load_player ()
  print("loading player...")
  player_entity.damage = 0
  basic.signal:emit('set_player_in_room', player_entity)
  basic.signal:emit('add_entity', 'player', player_entity)
  basic.signal:emit('add_sprite', 'player', player_sprite)
end

local function unload_player ()
  basic.signal:emit('remove_entity', player_entity)
  basic.signal:emit('remove_sprite', player_sprite)
end

function dungeon:enter ()
  -- connect every controller so they are loaded by pack
  controllers.player:connect()
  controllers.entities:connect()
  controllers.sprites:connect()
  controllers.notifications:connect()
  controllers.rooms:connect()
  -- load room and player
  --controllers.rooms:goto_room(1)
  load_player()
  --basic.signal:emit('locate_player', player_entity)
  print(player_entity.pos:unpack())
  camera:set_target(player_entity)
end

function dungeon:update ()
  controllers.player:update()
  controllers.entities:update()
  controllers.rooms:update()
  controllers.sprites:update()
  controllers.notifications:update()
  camera:update()
end

function dungeon:draw ()
  love.graphics.push()
  camera:draw()
  controllers.rooms:draw()
  controllers.entities:draw()
  controllers.sprites:draw()
  controllers.player:draw()
  controllers.notifications:draw()
  love.graphics.pop()
end

function dungeon:leave ()
  controllers.player:disconnect()
  controllers.entities:disconnect()
  controllers.rooms:disconnect()
  controllers.sprites:disconnect()
  controllers.notifications:disconnect()
  unload_player()
end

function dungeon:getentity (name)
  return controllers.entities:get(name)
end

function dungeon:getcamera ()
  return camera
end

return dungeon
