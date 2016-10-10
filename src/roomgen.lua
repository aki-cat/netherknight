
local roomgen = {}

function roomgen.generate (width, height, margin)
  local tilemap = require 'basic.matrix' :new {
    width + margin * 2,
    height + margin * 2,
    0
  }
  for i, j, tile in tilemap:iterate() do
    if i <= margin or
       j <= margin or
       i > tilemap:get_height() - margin or
       j > tilemap:get_width() - margin then
      tilemap:set(i, j, 2)
    else
      tilemap:set(i, j, 1)
    end
  end
  return tilemap
end

function roomgen.filter (tilemap)
  local patterns = require 'database.tilesets.patterns'
  local action_queue = {}

  -- first we find patterns in the tiles
  for _,pattern in ipairs(patterns) do
    local list = patterns.from_pattern_to_action(tilemap, pattern)
    for _,action in ipairs(list) do
      table.insert(action_queue, action)
    end
  end

  -- then we resolve the patterns' matches results
  for _,action in ipairs(action_queue) do
    tilemap:set(action[1], action[2], action[3])
  end
end

function roomgen.get_collision_map (tilemap)
  local collision_map = require 'basic.physics.collision_map' :new {
    tilemap:get_width(), tilemap:get_height()
  }
  for i, j, tile in tilemap:iterate() do
    if tile ~= 1 then
      collision_map:occupy_tile(j, i, 1)
    end
  end
  return collision_map
end

return roomgen
