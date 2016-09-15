
local game = basic.prototype:new {}
local controls = controls.game

local element_list = {}

function game:init()
  player = require 'player' :new { globals.width / 2, globals.height / 2 }
end

function game:enter()
  table.insert(element_list, player)
  controls:connect()
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
  controls:disconnect()
end

return game
