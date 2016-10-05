
local walls = basic.prototype:new {
  basic.matrix:new {},
  __type = 'walls'
}

function walls:__init ()
  local tiles = self[1]
  self.bodymap = require 'basic.physics.collision_map' :new { tiles:get_width(), tiles:get_height() }
  print('base tilemap dimensions:', tiles:get_width(), tiles:get_height())
  print('collision tilemap dimensions:', self.bodymap.map:get_width(), self.bodymap.map:get_height())
  for i, j, tile in tiles:iterate() do
    if tile ~= 1 then --and tile ~= 2 then
      self.bodymap:occupy_tile(j, i)
    end
  end
end

function walls:update_collisions (body)
  local t, r, b, l = body:get_edges()
  if self.bodymap:is_area_occupied(l, t, r - l, b - t) then
    basic.physics:treat_collision(body, self.bodymap)
  end
end

return walls
