
local globals = require 'globals'
local sprite = basic.pack 'database.sprites'

local game = basic.prototype:new {}

local drawable_list = {}
local slime

local function move_slime(action)
  local speed = .05
  if action == 'up' then
    slime[4] = slime[4] - speed
  elseif action == 'right' then
    slime[3] = slime[3] + speed
  elseif action == 'down' then
    slime[4] = slime[4] + speed
  elseif action == 'left' then
    slime[3] = slime[3] - speed
  end
end

function game:init()
  slime = basic.prototype:new (sprite.slime)
  slime[2] = slime.animations.idle.quads[1]
  slime[3], slime[4] = globals.width / 2, globals.height / 2
  table.insert(drawable_list, slime)
end

function game:enter()
  hump.signal.register(
    'holdkey',
    move_slime)
end

function game:update()
end

function game:draw()
  love.graphics.push()

  love.graphics.scale(globals.unit)
  for _,drawable in pairs(drawable_list) do
    love.graphics.draw(unpack(drawable))
  end

  love.graphics.pop()
end

function game:leave()
  hump.signal.remove('holdkey', move_slime)
end

return game
