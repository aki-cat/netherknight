
local game = require 'gamestate' :new {}
local controller = controllers.game
local sprites = basic.pack 'database.sprites'
local tilemaps = basic.pack 'database.tilemaps'

local indexed_drawables = {}
local room

function game:init ()
  room = require 'room' :new (tilemaps.default)
  local player_body = require 'player' :new { globals.width / 2, globals.height / 2, 1/2, 1/4 }
  local player_sprite = require 'sprite' :new { sprites.slime }
  self:add_body('player', player_body)
  self:add_drawable('player', player_sprite)
end

function game:enter ()
  for i = 1, 5 do
    local j = i < 3 and 1 or 3
    local slime_body = require 'monster' :new {
      (i % 3 + 1) * globals.width / 4,
      j * globals.height / 4,
      1/2, 1/4,
      species = 'slime' }
    local slime_sprite = require 'sprite' :new { sprites.slime }
    local name = 'slime' .. tostring(i)
    self:add_body(name, slime_body)
    self:add_drawable(name, slime_sprite)
  end
  controller:connect()
end

function game:update ()
  room:update()
  for bname,body in pairs(self.bodies) do
    if bname ~= '__length' then
      body:update()
      for anybname, anybody in pairs(self.bodies) do
        if anybname ~= '__length' then
          if body ~= anybody then body:checkandcollide(anybody) end
        end
      end
      room:update_collision(body)
      self:synchronize(bname)
    end
  end

  if not self:get_body('player') then
    hump.signal.emit('presskey', 'quit')
  end

  for dname, drawable in pairs(self.drawables) do
    if dname ~= '__length' then
      drawable:update()
    end
  end
  self:orderdrawables()
end

function game:draw ()
  love.graphics.push()

  love.graphics.setColor(255,255,255,255)
  love.graphics.scale(globals.unit)

  room:draw()

  for bname, body in pairs(self.bodies) do
    if bname ~= '__length' then
      body:draw()
    end
  end
  for dname, drawable in ipairs(indexed_drawables) do
    drawable:draw()
  end

  love.graphics.pop()
end

function game:leave ()
  controller:disconnect()
end

function game:orderdrawables ()
  if self.drawables.__length ~= #indexed_drawables then
    for i,v in ipairs(indexed_drawables) do indexed_drawables[i] = nil end
    for k,drawable in pairs(self.drawables) do
      if k ~= '__length' then
        table.insert(indexed_drawables, drawable)
      end
    end
  end
  table.sort(indexed_drawables, function(a,b) return a.pos.y < b.pos.y end)
end

return game
