
local dummy = {
  name = 'default',
  tileset = 'default',
  {
    {0,0,0},
    {0,0,0},
    {0,0,0},
  },
  {
    {0,0,0},
    {0,0,0},
    {0,0,0},
  },
}

local function iterate_tiles_in_layer (layer)
  local init_s = { tbl = layer, 1, 0 }
  return
    function(s, tile)
      local t = s.tbl
      s[2] = s[2] + 1
      local i, j = unpack(s)
      local tile = t[i][j]
      if not tile then
        s[1] = s[1] + 1
        s[2] = 1
        i, j = unpack(s)
        tile = t[i] and t[i][j]
      end
      return tile and i, j, tile
    end, -- f
    init_s,   -- s
    0    -- tile
end

local function create_layer (rows, cols)
  local rows = love.math.random(globals.height, 2 * globals.height)
  local cols = love.math.random(globals.width, 2 * globals.width)
  local layer = {}
  for i, rows do
    layer[i] = {}
    for j, cols do
      layer[i][j] = 0
    end
  end
  return layer
end

local function generate_walls (layer)
  local points = {}
  for i, j, tile in iterate_tiles_in_layer(layer) do
    if love.math.random() < .1 then
      table.insert(points, {i, j})
    end
  end
  for i, point in ipairs(points) do
    layer[point] = 
  end
end

local function generate_map ()
  local rows = love.math.random(globals.height / 2, globals.height)
  local cols = love.math.random(globals.width / 2, globals.width)
  local floor = create_layer (rows, cols)
end
