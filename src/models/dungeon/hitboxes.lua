
local hitboxes = require 'model' :new {}

local physics_util = require 'basic.physics'
local iterate = require 'basic.iterate'

function hitboxes:update ()
  local pool = self:get_pool()
  for index, body in ipairs(pool) do
    for jndex, body2 in iterate.other(pool, index) do
      if physics_util.rectangle_collision(body:get_area(), body2:get_area()) then
        print('collision!')
        print('>> body 1')
        print('pos', body:get_area():get_pos())
        print('size', body:get_area():get_size())
        print('>> body 2')
        print('pos', body2:get_area():get_pos())
        print('size', body2:get_area():get_size())
        signal.broadcast('collision', body:get_id(), body2:get_id())
      end
    end
  end
end

function hitboxes:draw ()
  local colors = require 'effects.colors'
  local pool = self:get_pool()
  colors.setRGBA(255,255,255,128)
  for index, body in ipairs(pool) do
    local area = body:get_area()
    local x, y = (area:get_pos() * globals.unit):unpack()
    local w, h = (area:get_size() * globals.unit):unpack()
    x = area.centred and x - w / 2 or x
    y = area.centred and y - h / 2 or y
    love.graphics.rectangle('fill', x, y, w, h)
  end
  colors.reset()
end

return hitboxes:new {}
