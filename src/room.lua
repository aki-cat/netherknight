
local tilesets = basic.pack 'database.tilesets'
local rooms = basic.pack 'database.rooms'
local iterate = require 'mapgen.iterate'

local room = basic.prototype:new {
  0, 0,
  tilemap = rooms.default,
  __type = 'room'
}

local function iterate_tiles (tilemap)
  local init_s = { tbl = tilemap, 1, 1, 0 }
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

local function get_obstacles (tilemap, blacklist, tilesize)
  local obstacles = {}
  for i, j, tile in iterate.matrix(tilemap) do
    if blacklist[tile] then
      local o = physics.static_body:new {
        j - 1,
        i - 1,
        tilesize / globals.unit,
        tilesize / globals.unit
      }
      table.insert(obstacles, o)
    end
  end
  return obstacles
end

function room:__init ()
  self.pos = basic.vector:new { self[1], self[2] }
  self.tilemap = self[3]
  self.name = self.name or self.tilemap.name or 'dummy'
  self.tileset = tilesets[self.tilemap.tileset]
  self.size = basic.vector:new { #self.tilemap[1], #self.tilemap }
  self.spritebatch = love.graphics.newSpriteBatch(self.tileset.img, 2048, 'stream')
  self.quads = get_quads(self.tileset.img, self.tileset.tilesize)
  self.obstacles = get_obstacles(self.tilemap, self.tileset.obstacles, self.tileset.tilesize)
  self:setup_buffer()
end

function room:setup_buffer ()
  local buffer = self.spritebatch
  buffer:clear()
  for i, j, tile in iterate.matrix(self.tilemap) do
    if self.quads[tile] then
      buffer:add(self.quads[tile], j-1, i-1, 0, 1 / globals.unit, 1 / globals.unit)
    end
  end
end

function room:check_collision (body)
  for i, tile in ipairs(self.obstacles) do
    body:check_collision_by_axis(tile)
  end
end

function room:update ()
  self:setup_buffer()
end

function room:draw ()
  love.graphics.draw(self.spritebatch, self.pos:unpack())
end

return room
