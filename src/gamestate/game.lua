
local game = basic.prototype:new {}

local element_list = {}
local player = require 'player' :new { globals.width / 2, globals.height / 2 }

local function move_player(action)
  local movement = basic.vector:new {}
  local speed = globals.frameunit * globals.unit / 64
  local angle = math.pi -- 180 degrees

  if action == 'up' then
    movement:set(math.cos(angle * 3/2) * speed, math.sin(angle * 3/2) * speed)
    player:move(movement)
  elseif action == 'right' then
    movement:set(math.cos(angle * 0/2) * speed, math.sin(angle * 0/2) * speed)
    player:move(movement)
  elseif action == 'down' then
    movement:set(math.cos(angle * 1/2) * speed, math.sin(angle * 1/2) * speed)
    player:move(movement)
  elseif action == 'left' then
    movement:set(math.cos(angle * 2/2) * speed, math.sin(angle * 2/2) * speed)
    player:move(movement)
  end
end

function game:init()
  table.insert(element_list, player)
end

function game:enter()
  hump.signal.register(
    'holdkey',
    move_player)
end

function game:update()
  for _,element in pairs(element_list) do
    element:update()
  end
end

function game:draw()
  love.graphics.push()

  love.graphics.scale(globals.unit)
  for _,element in pairs(element_list) do
    element:draw()
  end

  love.graphics.pop()
end

function game:leave()
  hump.signal.remove('holdkey', move_player)
end

return game
