
local walls = basic.prototype:new {
  basic.matrix:new {},
  __type = 'walls'
}

function walls:__init ()
  local tiles = self[1]
  self.bodylist = {}
  for i, j, tile in tiles:iterate() do
    if tile ~= 1 and tile ~= 2 then
      local body = require 'obstacle' :new{ j-1, i-1, 1, 1, centred = false }
      table.insert(self.bodylist, body)
    end
  end
end

function walls:update_collisions (body)
  for i,tile in ipairs(self.bodylist) do
    if basic.physics:rectangle_collision(body, tile) then
      basic.physics:treat_collision(body, tile)
    end
  end
end

return walls
