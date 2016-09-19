
local dungeon_sprites = require 'controller' :new {}

local dungeon = hump.gamestate.current()
local sprites = { __length = 0 }
local indexed_sprites = {}

local function ordersprites(sprites)
  if #indexed_sprites ~= sprites.__length then
    for i,_ in pairs(indexed_sprites) do indexed_sprites[i] = nil end
    for name, sprite in pairs(sprites) do
      if name ~= '__length' then table.insert(indexed_sprites, sprite) end
    end
  end
  table.sort(
    indexed_sprites,
    function(a,b)
      return a.pos.y < b.pos.y
    end
  )
end

function dungeon_sprites:update()
  for name, sprite in pairs(sprites) do
    if name ~= '__length' then sprite:update() end
  end
  ordersprites(sprites)
end

function dungeon_sprites:draw()
  for i, sprite in pairs(indexed_sprites) do sprite:draw() end
end

function dungeon_sprites:get (name)
  return sprites[name]
end

function dungeon_sprites:__init ()
  self.actions = {
    {
      signal = 'add_sprite',
      func = function(name, sprite)
        if sprite[name] then
          return error("Can't add second " .. name)
        end
        sprites[name] = sprite
        sprites.__length = sprites.__length + 1
      end
    },
    {
      signal = 'remove_sprite',
      func = function (name)
        sprites[name] = nil
        sprites.__length = sprites.__length - 1
      end
    },
    {
      signal = 'update_position',
      func = function (name, pos)
        if sprites[name] then sprites[name].pos:set(pos:unpack()) end
      end
    },
    {
      signal = 'shine_sprite',
      func = function(name, time)
        if sprites[name] then end
      end
    },
  }
end

return dungeon_sprites:new {}
