
local dungeon_player = require 'controller' :new {}

local sprites = basic.pack 'database.sprites'

local slash_entity = require 'attack' :new { 0, 0, 1/2, 1/2 }
local slash_sprite = require 'sprite' :new { sprites.slash }

local player_speed = globals.frameunit * 3/4

local function getplayer()
  return hump.gamestate.current():getentity('player')
end

local function animateslash (player, direction)
  slash_sprite:setrotation(math.atan2(direction.y, direction.x))
  direction.y = direction.y -1/4
  slash_entity.pos:set((player.pos + direction/4):unpack())
  hump.signal.emit('add_entity', 'slash', slash_entity)
  hump.signal.emit('add_sprite', 'slash', slash_sprite)
  hump.signal.emit('update_position', 'slash', slash_entity.pos)
  audio:playSFX('Slash')
  hump.timer.during(
    0.2,
    function()
      slash_entity.pos:set((player.pos + direction/4):unpack())
    end,
    function()
      hump.signal.emit('remove_entity', 'slash')
      hump.signal.emit('remove_sprite', 'slash')
    end
  )
end

local function attack (long)
  local player = getplayer()
  if not player or player.locked then return end
  local direction = player:getdirection()
  if long then
    print('long attack!')
    player:lock(0.5)
    player:move(direction * 0.3)
  else
    print('short attack!')
    player:lock(0.3)
  end
  animateslash(player, direction)
end

local presskey = {
  maru = function() attack(false) end,
  batsu = function() attack(true) end,
  quit = function() hump.signal.emit('quit_game') end,
  inventory = function()
    local player = getplayer()
    for key, item in pairs(gamedata.inventory) do
      if item == 'drumstick' then
        audio:playSFX('Heal')
        player.damage = 0
        gamedata.inventory[key] = nil
        return
      end
    end
  end,
}

function dungeon_player:__init ()
  self.actions = {
    {
      signal = 'holdkey',
      func = function (action)
        local player = getplayer()
        local direction = physics.dynamic_body.direction[action]
        if not direction then return end
        if player.locked then return end
        player:face(action)
        player:move(direction * player_speed)
      end
    },
    {
      signal = 'presskey',
      func = function (action)
        if presskey[action] then presskey[action]() end
      end
    },
    {
      signal = 'get_item',
      func = function (item)
        local player = getplayer()
        audio:playSFX('Get')
        table.insert(gamedata.inventory, item)
        module.notification:new {
          'item',
          player.pos.x, player.pos.y,
          value = 1,
          text = item
        }
      end
    },
    {
      signal = 'get_money',
      func = function (ammount)
        local player = getplayer()
        audio:playSFX('Get')
        gamedata.money = gamedata.money + ammount
        module.notification:new {
          'money',
          player.pos.x, player.pos.y,
          value = ammount,
          text = 'gold'
        }
      end
    },
  }
end

return dungeon_player:new {}
