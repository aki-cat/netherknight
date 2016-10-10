
local rooms = require 'controller' :new { 'dungeon' }

local vector = require 'basic.vector'
local matrix = require 'basic.matrix'

function rooms:__init ()
  local map = self:get_model('map')
  local physics = self:get_model('physics')
  local spritebatch = self:get_model('spritebatch')

  local directions = {
    up = vector:new { -1, 0 },
    down = vector:new { 1, 0 },
    left = vector:new { 0, -1 },
    right = vector:new { 0, 1 },
  }

  self:register_action('set_room', function (id)
    local room = map:get_element(id)
    if not room then return end

    physics:set_map(room:get_collision_map())
    spritebatch:set_current(id)
    print('ROOM SET!')
  end)

end

return rooms:new {}
