
local dungeon_sprites = require 'controller' :new {}
local sprites_db = basic.pack 'database.sprites'

local dungeon = hump.gamestate.current()
local sprites = { __length = 0 }
local indexed_sprites = {}

local function ordersprites(sprites)
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

local function find_sprite (sprite)
  for name, s in pairs(sprites) do
    if sprite == s then return name end
  end
end

function dungeon_sprites:__init ()
  self.actions = {
    {
      signal = 'add_sprite',
      func = function (name, sprite)
        if sprite[name] then
          return error("Can't add second sprite " .. name)
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
        local sprite = sprites[name] or find_sprite(name)
        if sprite then
          sprite:shine(time)
        end
      end
    },
    {
      signal = 'turn_white',
      func = function (name)
        local sprite = sprites[name] or find_sprite(name)
        if sprite then
          sprite.alpha = 200
          sprite.brightness = 100
        end
      end
    },
    {
      signal = 'blink',
      func = function (name, speed, time)
        local sprite = sprites[name] or find_sprite(name)
        if sprite then
          local s = .075
          if     speed == 'fast' then s = .05
          elseif speed == 'slow' then s = .1 end
          basic.timer:every(s, function () sprite.alpha = sprite.alpha == 80 and 255 or 80 end, time/s)
        end
      end
    },
    {
      signal = 'freeze_animation',
      func = function (name)
        local sprite = sprites[name] or find_sprite(name)
        if sprite then
          sprite:freezeanimation()
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
    {
      signal = 'monster_slay',
      func = function (monster)
        local death = module.sprite:new { sprites_db.death }
        death.pos = monster.pos
        hump.signal.emit('add_sprite', death, death)
        basic.timer:after(
          0.6,
          function ()
            hump.signal.emit('remove_sprite', death)
          end
        )
      end
    },
    {
      signal = 'player_walk',
      func = function ()
        local playersprite = sprites['player']
        playersprite:setanimation('walking')
      end
    },
    {
      signal = 'player_idle',
      func = function ()
        local playersprite = sprites['player']
        playersprite:setanimation('default')
      end
    }
  }
end

return dungeon_sprites:new {}
