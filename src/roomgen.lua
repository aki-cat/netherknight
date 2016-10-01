
local room = basic.matrix:new {
  -- width, height, default value,
  __type = 'room'
}

function room:generate ()
  for i, j, tile in self:iterate() do
    if i < 3 or j < 3 or i > self:get_height() - 3 or j > self:get_width() - 3 then
      tile = 2
    else
      tile = 1
    end
  end
  self:filter()
end

function room:filter ()
  local patterns = require 'database.tilesets.patterns'
  local action_queue = {}
  -- first we find patterns in the tiles
  for _,pattern in ipairs(patterns) do
    local list = patterns.from_pattern_to_action(self, pattern)
    for _,action in ipairs(list) do
      table.insert(action_queue, action)
    end
  end
  -- then we resolve the patterns' matches results
  for _,action in ipairs(action_queue) do
    self:set(action[1], action[2], action[3])
  end
end

function room:__init ()
  -- code...
end

return room
