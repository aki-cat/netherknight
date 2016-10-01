
local dictionary = {
  idc = '*',
  nothing = 0,
  floor = 1,
  wall = 2,
  wall_up = 3,
  wall_right = 4,
  wall_up_left = 5,
  wall_up_right = 6,
  wall_elbow_up_left = 7,
  wall_elbow_up_right = 8,
  wall_down = 11,
  wall_left = 12,
  wall_down_left = 13,
  wall_down_right = 14,
  wall_elbow_down_left = 15,
  wall_elbow_down_right = 16,
}

local patterns = {
  {
    { '*', '*', '*', },
    { '*', -1,  '*', },
    { '*',  1,  '*', },
    result = dictionary.wall_up
  },
  {
    { '*', '*', '*', },
    {  1,  -1,  '*', },
    { '*', '*', '*', },
    result = dictionary.wall_right
  },
  {
    { '*',  1,  '*', },
    { '*', -1,  '*', },
    { '*', '*', '*', },
    result = dictionary.wall_down
  },
  {
    { '*', '*', '*', },
    { '*', -1,   1,  },
    { '*', '*', '*', },
    result = dictionary.wall_left
  },
  {
    { '*', '*', '*', },
    { '*', -1,  -1,  },
    { '*', -1,   1,  },
    result = dictionary.wall_up_left
  },
  {
    { '*', '*', '*', },
    { -1,  -1,  '*', },
    {  1,  -1,  '*', },
    result = dictionary.wall_up_right
  },
  {
    { '*', -1,   1,  },
    { '*', -1,  -1,  },
    { '*', '*', '*', },
    result = dictionary.wall_down_left
  },
  {
    {  1,  -1,  '*', },
    { -1,  -1,  '*', },
    { '*', '*', '*', },
    result = dictionary.wall_down_right
  },
  {
    { '*',  1,   1,  },
    { -1,  -1,   1,  },
    { -1,  -1,  '*', },
    result = dictionary.wall_elbow_up_right
  },
  {
    {  1,   1,  '*', },
    {  1,  -1,  -1,  },
    { '*', -1,  -1,  },
    result = dictionary.wall_elbow_up_left
  },
  {
    { '*', -1,  -1,  },
    {  1,  -1,  -1,  },
    {  1,   1,  '*', },
    result = dictionary.wall_elbow_down_left
  },
  {
    { -1,  -1,  '*', },
    { -1,  -1,   1,  },
    { '*',  1,   1,  },
    result = dictionary.wall_elbow_down_right
  },
}

function patterns.from_pattern_to_action (tilemap, pattern)
  local rows, columns = #pattern, #pattern[1]
  local halfw, halfh = math.floor(columns / 2) + 1, math.floor(rows / 2) + 1
  local actions = {}
  local iterate = require 'basic.iterate'

  -- iterate through tilemap
  for i, j, tile in iterate.matrix(tilemap) do
    -- assume there is potential in this tile
    local potential = true
    -- iterate through pattern
    for m, n, expected in iterate.matrix(pattern) do
      -- compare all adjacent tiles
      local di, dj = i + m - halfw, j + n - halfh
      -- check for the "anything" case
      if expected ~= '*' then
        -- existence condition (if not, we still assume it's not a pattern match)
        if not tilemap[di] or tilemap[di][dj] == nil then
          potential = false
        else
          -- check for specific case
          if expected + tilemap[di][dj] == 0 then
            -- if its negative and of same value
            potential = false
          elseif expected > 0 and tilemap[di][dj] ~= expected then
            -- if it simply doesn't match
            potential = false
          end
        end
      end
    end
    -- if everything is checked, then
    if potential then table.insert(actions, { i, j, pattern.result }) end
  end
  -- return all actions as a queue of sorts
  return actions
end

return patterns
