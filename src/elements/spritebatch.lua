
local matrix = require 'basic.matrix'
local tilesize = globals.unit

local spritebatch = require 'element' :new {
  'default',
  matrix:new {},
  __type = 'spritebatch'
}

function spritebatch:__init ()
  local image = love.graphics.newImage('assets/images/tileset-' .. self[1] .. '.png')
  local tiles = self[2]
  self.tilemap = love.graphics.newSpriteBatch(image, 1280, 'static')
  self:get_quads(image)
  self:setup_buffer(tiles)
end

function spritebatch:get_quads (image)
  self.quads = {}
  local width, height = image:getWidth() / tilesize, image:getHeight() / tilesize

  for i = 1, height do
    for j = 1, width do
      local q = love.graphics.newQuad(
        (j - 1) * tilesize,
        (i - 1) * tilesize,
        tilesize, tilesize,
        image:getDimensions()
      )
      table.insert(self.quads, q)
    end
  end
end

function spritebatch:setup_buffer (tiles)
  local buffer = self.tilemap
  buffer:clear()
  for i, j, tile in tiles:iterate() do
    if self.quads[tile] then
      buffer:add(self.quads[tile], tilesize * (j-1), tilesize * (i-1), 0, 1, 1)
    end
  end
end

function spritebatch:draw ()
  love.graphics.draw(self.tilemap, 0, 0)
end

return spritebatch
