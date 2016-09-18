
local sprites = basic.pack 'database.sprites'

local dungeon_controller = {}

local slash_body = require 'attack' :new { 0, 0, 1, 1 }
local slash_sprite = require 'sprite' :new { sprites.slash }
local dash_speed = 0.3
local directions = {
  right      = math.pi * 0/4,
  down_right = math.pi * 1/4,
  down       = math.pi * 2/4,
  down_left  = math.pi * 3/4,
  left       = math.pi * 4/4,
  up_left    = math.pi * 5/4,
  up         = math.pi * 6/4,
  up_right   = math.pi * 7/4
}

local function animateslash (player, dist)
  slash_sprite:setrotation(math.atan2(dist.y, dist.x))
  dist:add{0, -1/4, 0}
  slash_body.pos:set((player.pos + dist/4):unpack())
  hump.gamestate.current():add_body('slash', slash_body)
  hump.gamestate.current():add_drawable('slash', slash_sprite)
  hump.timer.after(
    0.2,
    function()
      hump.gamestate.current():del_body('slash') hump.timer.clear()
      hump.gamestate.current():del_drawable('slash') hump.timer.clear()
    end
  )
  hump.timer.every(
    globals.frameunit,
    function()
      slash_body.pos:set((player.pos + dist/4):unpack())
    end
  )
end

local function longattack (player, dirangle)
  print('long attack!')
  local dist = basic.vector:new { math.cos(dirangle), math.sin(dirangle) }
  animateslash(player, dist*1)
  dist:mul(dash_speed)
  player:lock(0.5)
  player.speed:add(dist)
end

local function shortattack (player, dirangle)
  print('short attack!')
  local dist = basic.vector:new { math.cos(dirangle), math.sin(dirangle) }
  player:lock(0.3)
  animateslash(player, dist)
end

dungeon_controller.input_attack = {
  signal = 'presskey',
  func = function (action)
    local player = hump.gamestate.current():get_body('player')
    if not player or player.locked then return end
    local dir = player:getdirection()
    if action == 'maru' then
      shortattack(player, dir)
    elseif action == 'batsu' then
      longattack(player, dir)
    elseif action == 'marco' then
      local alpha = 255
      hump.timer.every(
        globals.frameunit,
        function ()
          local pos = tostring(hump.gamestate.current():get_body('player').pos.x) .. ', ' .. tostring(hump.gamestate.current():get_body('player').pos.y)
          alpha = alpha - 1
          hump.signal.emit('debug_print', {
            string = "MARCO...",
            alpha = alpha
          })
          hump.signal.emit('debug_print', {
            string = "POLO!",
            alpha = alpha
          })
          hump.signal.emit('debug_print', {
            string = pos,
            alpha = alpha
          })
        end,
        240
      )
    elseif action == 'inventory' then
      for key, item in pairs(gamedata.inventory) do
        if item == 'drumstick' then
          hump.gamestate.current():get_body('player').damage = 0
          gamedata.inventory[key] = nil
          audio:playSFX('Heal')
          return
        end
      end
    elseif action == 'pause' then
    end
  end
}

dungeon_controller.input_move_player = {
  signal = 'holdkey',
  func = function (action)
    if     action == 'maru' or action == 'batsu'
        or action == 'quit' or action == 'marco'
        or action == 'inventory' or action == 'pause'
      then return
    end
    local player = hump.gamestate.current():get_body('player')
    if not player or player.locked then return end
    local movement = basic.vector:new {}
    local speed = globals.frameunit * globals.unit / 64
    movement:set(speed * math.cos(directions[action]), speed * math.sin(directions[action]))
    player:face(action)
    player:move(movement)
  end
}

dungeon_controller.body_collision = {
  signal = 'body_collision',
  func = function (body, somebody)
    body:on_collision(somebody)
  end
}

dungeon_controller.body_death = {
  signal = 'body_death',
  func = function(somebody)
    local scene = hump.gamestate.current()
    local bodyname = scene:find_body(somebody)
    if bodyname then
      print("DEATH:", bodyname)
      scene:del_body(bodyname)
      scene:del_drawable(bodyname)
    end
  end
}

dungeon_controller.body_immunity = {
  signal = 'body_immunity',
  func = function(body, immune)
    local scene = hump.gamestate.current()
    local name = scene:find_body(body)
    local sprite = scene:get_sprite(name)
    local shine = immune and 40 or 0
    if name and sprite then sprite.shine = shine end
  end
}

return require 'controller' :new { actions = dungeon_controller }
