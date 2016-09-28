
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

function dungeon_player:update ()
  if gamedata.exp >= math.floor(.5 + 10 + 1.05 ^ gamedata.level) then
    local player = getplayer()
    gamedata.exp = 0
    gamedata.level = gamedata.level + 1
    audio:playSFX('Grow')
    module.notification:new {
      'level',
      player.pos.x, player.pos.y,
      value = false,
      text = 'level up!'
    }
    hump.signal.emit('rise_the_bling', gamedata.level)
  end
end

function dungeon_player:draw ()
  local player = getplayer()
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  fonts:set(1)
  love.graphics.printf(
    'LV '..tostring(gamedata.level),
    globals.unit * (player.pos.x - 1),
    globals.unit * (player.pos.y - 1),
    globals.unit * 2,
    'center'
  )
  local currenthp = (player.maxhp - player.damage) * gamedata.level
  local maxhp = player.maxhp * gamedata.level
  love.graphics.printf(
    'HP '..tostring(currenthp) .. ' / ' .. tostring(maxhp),
    globals.unit * (player.pos.x - 1),
    globals.unit * (player.pos.y - 1 - 1/4),
    globals.unit * 2,
    'center'
  )
  love.graphics.pop()
end

function dungeon_player:__init ()
  self.actions = {
    {
      signal = 'hold_direction',
      func = function (direction)
        local player = getplayer()
        if player.locked or player:isdead() then return end
        if direction == 'none' then hump.signal.emit('player_idle') return end
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
        basic.timer:every(.05, function ()
          audio:playSFX('Coin')
        end, ammount)
        gamedata.money = gamedata.money + ammount
        module.notification:new {
          'money',
          player.pos.x, player.pos.y,
          value = ammount,
          text = 'gp'
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
          value = ammount * gamedata.level,
        }
      end
    },
    {
      signal = 'gain_exp',
      func = function (monster)
        local exp = math.floor((monster.attack + monster.maxhp) * (0.75 + love.math.random() * 0.5))
        gamedata.exp = gamedata.exp + exp
        module.notification:new { 'expgain', monster.pos.x, monster.pos.y, value = exp, text = 'xp' }
      end
    }
  }
end

return dungeon_player:new {}
