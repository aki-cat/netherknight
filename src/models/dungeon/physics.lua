
local physics = require 'model' :new {}

local physics_util = require 'basic.physics'
local iterate = require 'basic.iterate'

function physics:__init ()
  self.tiles = require 'basic.physics.collision_map' :new {}
end

function physics:set_map (collision_map)
  self.tiles = collision_map
end

function physics:update ()
  local pool = self:get_pool()
  for index, body in ipairs(pool) do
    body:update()
    --[[
    
    for jndex, body2 in iterate.other(pool, index) do
      if physics_util.rectangle_collision(body:get_physics(), body2:get_physics()) then
        print("Physical body collision:", body:get_id(), body2:get_id())
        physics_util.treat_body_collision(body:get_physics(), body2:get_physics())
        physics_util.treat_body_collision(body2:get_physics(), body:get_physics())
      end
    end

    ]]
    physics_util.treat_collision(body:get_physics(), self.tiles)
    signal.broadcast('position', body:get_id(), body:get_physics():get_pos())
  end
end

function physics:draw ()
  local colors = require 'effects.colors'
  colors.setRGBA(255,180,180,200)
  local pool = self:get_pool()
  for index, body in ipairs(pool) do
    local t, r, b, l = body:get_physics():get_edges()
    local w, h = r - l, b - t
    love.graphics.rectangle('fill', l * globals.unit, t * globals.unit, w * globals.unit, h * globals.unit)
  end
  colors.reset()
end

return physics:new {}
