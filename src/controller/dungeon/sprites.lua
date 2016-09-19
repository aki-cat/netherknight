
local dungeon_sprites = require 'controller' :new {}

local dungeon = hump.gamestate.current()
local sprites = {}
local roomtiles

function dungeon_sprites:update()
  for name, sprite in pairs(sprites) do
    sprite:update()
  end
  roomtiles:update()
end

function dungeon_sprites:draw()
  for name, sprite in pairs(sprites) do
    sprite:draw()
  end
  roomtiles:draw()
end

function dungeon_sprites:get (name)
  return sprites[name]
end
