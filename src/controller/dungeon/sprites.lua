
local dungeon_sprites = require 'controller' :new {}

local dungeon = hump.gamestate.current()
local sprites = { __length = 0 }
local indexed_sprites = {}

local function ordersprites(sprites)
  print("Reordering sprite list")
  for i,_ in pairs(indexed_sprites) do indexed_sprites[i] = nil end
  for name, sprite in pairs(sprites) do
    if name ~= '__length' then table.insert(indexed_sprites, name) end
  end
  table.sort(
    indexed_sprites,
    function(a,b)
      return sprites[a].pos.y < sprites[b].pos.y
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
  for i, name in ipairs(indexed_sprites) do
    if name ~= '__length' then sprites[name]:draw() end
  end
end

function dungeon_sprites:get (name)
  return sprites[name]
end

function dungeon_sprites:__init ()
  self.actions = {
    {
      signal = 'add_sprite',
      func = function (name, sprite)
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
        if sprites[name] ~= nil then
          sprites[name] = nil
          sprites.__length = sprites.__length - 1
        end
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
      func = function (name, time)
        if sprites[name] then
          sprites[name]:shine(time)
        end
      end
    },
    {
      signal = 'change_animation',
      func = function (name, animation)
        if sprites[name] then
          sprites:setanimation(animation)
        end
      end
    },
    {
      signal = 'flip_horizontal',
      func = function (name, flip)
        if sprites[name] then
          sprites[name]:setflip('h', flip)
        end
      end
    },
  }
end

return dungeon_sprites:new {}
