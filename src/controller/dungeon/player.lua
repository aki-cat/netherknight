
local dungeon_player = require 'controller' :new {}

local sprites = basic.pack 'database.sprites'

local slash_entity = require 'attack' :new { 0, 0, }
local slash_sprite = require 'sprite' :new { sprites.slash }

local player_speed = globals.frameunit * 3/4

local function getplayer()
  return hump.gamestate.current():getentity('player')
end

local function animateslash (player, direction)
  if direction.x < 0 then
    slash_sprite:setrotation(math.atan2(-direction.y, 1))
    slash_sprite:setflip('h', true)
  elseif direction.x > 0 then
    slash_sprite:setrotation(math.atan2(direction.y, 1))
    slash_sprite:setflip('h', false)
  end
  if player.dir == 'down' then
    slash_sprite:setrotation(math.pi / 2)
    slash_sprite:setflip('v', true)
  else
    slash_sprite:setflip('v', false)
  end
  if player.dir == 'up' then
    slash_sprite:setrotation(math.pi / 2)
  end
  print(player.dir)
  slash_sprite:playanimation()
  direction.y = direction.y -1/4
  local pos = player.pos + direction/2
  slash_entity.pos:set(pos:unpack())
  basic.signal:emit('add_entity', 'slash', slash_entity)
  basic.signal:emit('add_sprite', 'slash', slash_sprite)
  basic.signal:emit('update_position', 'slash', slash_entity.pos)
  audio:playSFX('Slash')
  basic.timer:during(
    0.2,
    function()
      local pos = player.pos + direction/2
      slash_entity.pos:set(pos:unpack())
    end,
    function()
      basic.signal:emit('remove_entity', 'slash')
      basic.signal:emit('remove_sprite', 'slash')
    end
  )
end

local function attack (long)
  local player = getplayer()
  if not player or player.locked then return end
  basic.signal:emit('player_animation', 'attack')
  local direction = physics.dynamic_body.getdirection(player.dir)
  if long then
    print('long attack!')
    player:move(direction * 0.3)
    player:lock(0.5)
    basic.timer:after(0.5, function ()
      basic.signal:emit('player_animation', 'default')
    end)
  else
    print('short attack!')
    player:lock(0.3)
    basic.timer:after(0.3, function ()
      basic.signal:emit('player_animation', 'default')
    end)
  end
  animateslash(player, direction)
end

local press_actions = {
  maru = function() attack(false) end,
  batsu = function() attack(true) end,
  quit = function() basic.signal:emit('quit_game') end,
  inventory = function()
    local player = getplayer()
    for key, item in pairs(gamedata.inventory) do
      if item == 'drumstick' then
        gamedata.inventory[key] = nil
        basic.signal:emit('heal_player', math.floor(player.maxhp/2))
        return
      end
    end
  end,
}

function dungeon_player:update ()
  if gamedata.exp >= math.floor((1 + gamedata.level) * (20 + 1.5 ^ gamedata.level)) then
    local player = getplayer()
    gamedata.exp = 0
    gamedata.level = gamedata.level + 1
    audio:playSFX('Grow')
    player.maxhp = player.maxhp + gamedata.level * 5
    module.notification:new {
      'level',
      player.pos.x, player.pos.y,
      value = false,
      text = 'level up!'
    }
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
  love.graphics.pop()
end

function dungeon_player:__init ()
  self.actions = {
    {
      signal = 'hold_direction',
      func = function (direction)
        local player = getplayer()
        if player.locked or player:isdead() then return end
        if direction == 'none' then basic.signal:emit('player_animation', 'default') return end
        local movement = physics.dynamic_body.getdirection(direction) * player_speed
        player:face(direction)
        player:move(movement)
        basic.signal:emit('player_animation', 'walking')
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
        player.damage = player.damage - ammount
        if player.damage < 0 then player.damage = 0 end
        module.notification:new {
          'heal',
          player.pos.x, player.pos.y,
          value = ammount,
        }
      end
    },
    {
      signal = 'gain_exp',
      func = function (monster)
        local strength = monster.attack + monster.maxhp
        local exp = math.floor(1 + strength * (0.75 + love.math.random() * 0.5))
        gamedata.exp = gamedata.exp + exp
        module.notification:new { 'expgain', monster.pos.x, monster.pos.y, value = exp, text = 'xp' }
      end
    }
  }
end

return dungeon_player:new {}
