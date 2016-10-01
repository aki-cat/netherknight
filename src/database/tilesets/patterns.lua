
local iterate = require 'basic.iterate'

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
    {   2,  2,   2,  },
    { '*',  1,  '*', },
    result = dictionary.wall_up
  },
  {
    { '*',  2,  '*', },
    {  1,   2,  '*', },
    { '*',  2,  '*', },
    result = dictionary.wall_right
  },
  {
    { '*',  1,  '*', },
    {  2,   2,   2,  },
    { '*', '*', '*', },
    result = dictionary.wall_down
  },
  {
    { '*',  2,  '*', },
    { '*',  2,   1,  },
    { '*',  2,  '*', },
    result = dictionary.wall_left
  },
  {
    { '*', '*', '*', },
    { '*',  2,   2,  },
    { '*',  2,   1,  },
    result = dictionary.wall_up_left
  },
  {
    { '*', '*', '*', },
    {  2,   2,  '*', },
    {  1,   2,  '*', },
    result = dictionary.wall_up_right
  },
  {
    { '*',  2,   1,  },
    { '*',  2,   2,  },
    { '*', '*', '*', },
    result = dictionary.wall_down_left
  },
  {
    {  1,   2,  '*', },
    {  2,   2,  '*', },
    { '*', '*', '*', },
    result = dictionary.wall_down_right
  },
  {
    { '*',  1,   1,  },
    {  2,   2,   1,  },
    {  2,   2,  '*', },
    result = dictionary.wall_elbow_up_right
  },
  {
    {  1,   1,  '*', },
    {  1,   2,   2,  },
    { '*',  2,   2,  },
    result = dictionary.wall_elbow_up_left
  },
  {
    { '*',  2,   2,  },
    {  1,   2,   2,  },
    {  1,   1,  '*', },
    result = dictionary.wall_elbow_down_left
  },
  {
    {  2,   2,  '*', },
    {  2,   2,   1,  },
    { '*',  1,   1,  },
    result = dictionary.wall_elbow_down_right
  },
}

function patterns.from_pattern_to_action (tilemap, pattern)
  local rows, columns = #pattern, #pattern[1]
  local halfw, halfh = math.floor(columns / 2) + 1, math.floor(rows / 2) + 1
  local actions = {}

  -- iterate through tilemap
  for i, j, tile in iterate.matrix() do
    -- assume there is potential in this tile
    local potential = true
    -- iterate through pattern
    for m, n, expected in iterate.matrix(pattern) do
      -- compare all adjacent tiles
      local di, dj = i + m - halfw, j + n - halfh
      -- existence condition (if not, we still assume it's not a pattern match)
      if not map[di] or map[di][dj] == nil then
        potential = false
      else
        -- check for special cases
        if expected ~= '*' and expected + map[di][dj] ~= 0 then
          -- check for specific case
          if map[di][dj] ~= expected then
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
