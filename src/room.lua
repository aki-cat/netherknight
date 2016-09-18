
local tilesets = basic.pack 'database.tilesets'
local maps = basic.pack 'database.maps'

local room = basic.prototype:new {
  pos = basic.vector:new {},
  map = maps.default,
  --tileset = tilesets.default,
  obstacles = {},
  map = {
    {
      {0, 0, 0},
      {0, 0, 0},
      {0, 0, 0},
    },
    {
      {0, 0, 0},
      {0, 0, 0},
      {0, 0, 0},
    }
  },
  __type = 'room'
}

local function iterate_tiles (map)
  local init_s = { tbl = map, 1, 1, 0 }
  return
    function(s, tile)
      local t = s.tbl
      s[3] = s[3] + 1
      local layer, i, j = unpack(s)
      local tile = t[layer][i][j]
      if not tile then
        s[2] = s[2] + 1
        s[3] = 1
        layer, i, j = unpack(s)
        tile = t[layer][i] and t[layer][i][j]
        if not tile then
          s[1] = s[1] + 1
          s[2] = 1
          s[3] = 1
          layer, i, j = unpack(s)
          tile = t[layer] and t[layer][i] and t[layer][i][j]
        end
      end
      return tile and layer, tile, i, j
    end, -- f
    init_s,   -- s
    0    -- tile
end

local function get_quads(image, tilesize)
  local quads = {}
  local width, height = image:getWidth() / tilesize, image:getHeight() / tilesize

  for i = 1, height do
    for j = 1, width do
      local q = love.graphics.newQuad(
        (j - 1) * tilesize,
        (i - 1) * tilesize,
        tilesize, tilesize,
        image:getDimensions()
      )
      table.insert(quads, q)
    end
  end
  return quads
end

local function get_obstacles (map, blacklist, tilesize)
  print(map, blacklist, tilesize)
  local obstacles = {}
  for layer, tile, i, j in iterate_tiles(map) do
    if blacklist[tile] then
      local o = physics.collision_body:new {
        (j - 1),
        (i - 1),
        tilesize / globals.unit,
        tilesize / globals.unit,
        centred = false
      }
      table.insert(obstacles, o)
    end
  end
  return obstacles
end

function room:__init ()
  self.name = self.map.name
  self.tileset = tilesets[self.map.tileset]
  self.spritebatch = love.graphics.newSpriteBatch(self.tileset.img, 2048, 'stream')
  self.quads = get_quads(self.tileset.img, self.tileset.tilesize)
  self.obstacles = get_obstacles(self.map, self.tileset.obstacles, self.tileset.tilesize)
  self:setup_buffer()
end

function room:setup_buffer ()
  local buffer = self.spritebatch
  buffer:clear()
  for layer, tile, i, j in iterate_tiles(self.map) do
    if self.quads[tile] then
      buffer:add(self.quads[tile], j-1, i-1, 0, 1 / globals.unit, 1 / globals.unit)
    end
  end
end

function room:update_collision (body)
  for i, tile in ipairs(self.obstacles) do
    body:checkandcollide(tile)
  end
end

function room:update ()
  self:setup_buffer()
end

function room:draw ()
  love.graphics.draw(self.spritebatch, self.pos:unpack())
end

return room
