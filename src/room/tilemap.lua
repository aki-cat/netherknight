
local tilemap = basic.prototype:new {
  'default',
  basic.matrix:new {},
  __type = 'tilemap'
}

local tilesize = globals.unit

function tilemap:__init ()
  local tilesets_path = 'assets/images/tileset-'
  local image = love.graphics.newImage(tilesets_path .. self[1] .. '.png')
  self.tilemap = self[2]
  self.spritebatch = love.graphics.newSpriteBatch(image, 1280, 'stream')
  self:getquads(image)
end

function tilemap:getquads (image)
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

function tilemap:update ()
  local buffer = self.spritebatch
  buffer:clear()
  for i, j, tile in self.tilemap:iterate() do
    if self.quads[tile] then
      buffer:add(self.quads[tile], tilesize * (j-1), tilesize * (i-1), 0, 1, 1)
    end
  end
end

function tilemap:draw ()
  love.graphics.draw(self.spritebatch, 0, 0)
end

return tilemap
