
local game = basic.prototype:new {}
local controls = controls.game

local element_list = {}

function game.getplayer ()
  return element_list.player
end

function game:addelement (name, element)
  assert(not element_list[name], "Cannot add second element of same name.")
  element_list[name] = element
end

function game:delelement (name)
  assert(element_list[name], "Cannot remove element that doesn't exist.")
  element_list[name] = nil
end

function game:init()
  local player = require 'body' :new { globals.width / 2, globals.height / 2 }
  self:addelement('player', player)
end

function game:enter()
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
