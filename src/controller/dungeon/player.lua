
local dungeon_player = require 'controller' :new {}

local sprites = basic.pack 'database.sprites'

local slash_entity = require 'attack' :new { 0, 0, 2/3, 2/3 }
local slash_sprite = require 'sprite' :new { sprites.slash }

local player_speed = globals.frameunit * 3/4

local function getplayer()
  return hump.gamestate.current():getentity('player')
end

local function animateslash (player, direction)
  slash_sprite:setrotation(math.atan2(direction.y, direction.x))
  direction.y = direction.y -1/4
  slash_entity.pos:set((player.pos + direction/2):unpack())
  hump.signal.emit('add_entity', 'slash', slash_entity)
  hump.signal.emit('add_sprite', 'slash', slash_sprite)
  hump.signal.emit('update_position', 'slash', slash_entity.pos)
  audio:playSFX('Slash')
  basic.timer:during(
    0.2,
    function()
      slash_entity.pos:set((player.pos + direction/2):unpack())
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

local press_actions = {
  maru = function() attack(false) end,
  batsu = function() attack(true) end,
  quit = function() hump.signal.emit('quit_game') end,
  inventory = function()
    local player = getplayer()
    for key, item in pairs(gamedata.inventory) do
      if item == 'drumstick' then
        gamedata.inventory[key] = nil
        hump.signal.emit('heal_player', 5)
        return
      end
    end
  end,
}

function dungeon_player:__init ()
  self.actions = {
    {
      signal = 'hold_direction',
      func = function (direction)
        if direction == 'none' then hump.signal.emit('player_idle') return end
        local player = getplayer()
        if player.locked then return end
        local movement = physics.dynamic_body.direction[direction] * player_speed
        player:face(direction)
        player:move(movement)
        hump.signal.emit('player_walk')
      end
    },
    {
      signal = 'press_action',
      func = function (action)
        if press_actions[action] then press_actions[action]() end
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
        basic.timer:every(.1, function ()
          audio:playSFX('Coin')
        end, ammount)
        gamedata.money = gamedata.money + ammount
        module.notification:new {
          'money',
          player.pos.x, player.pos.y,
          value = ammount,
          text = 'gold'
        }
      end
    },
    {
      signal = 'heal_player',
      func = function (ammount)
        local player = getplayer()
        audio:playSFX('Heal')
        player.damage = (player.damage - ammount) >= 0 and player.damage - ammount or 0
        module.notification:new {
          'heal',
          player.pos.x, player.pos.y,
          value = ammount,
        }
      end
    }
  }
end

return dungeon_player:new {}
