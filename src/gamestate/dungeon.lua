
local dungeon = require 'gamestate' :new {}
local controller = controllers.dungeon
local sprites = basic.pack 'database.sprites'
local rooms = basic.pack 'database.rooms'

local indexed_drawables = {}
local map = {}
local roomdata = {}
local current_room

function dungeon:init ()
  local player_body = require 'player' :new { globals.width / 2, globals.height / 2, 1/2, 1/4 }
  local player_sprite = require 'sprite' :new { sprites.slime }
  self:add_body('player', player_body)
  self:add_drawable('player', player_sprite)
end

function dungeon:enter ()
  self:changeroom('empty')
  self:changeroom('default')
  local drumstick_body = require 'collectable' :new {
    item = 'drumstick',
    globals.width /2, globals.height /2,
    36/globals.unit, 24/globals.unit
  }
  local drumstick_sprite = require 'sprite' :new { sprites.drumstick }
  roomdata.empty.entities.drumstick = drumstick_body
  for i = 1, 5 do
    local j = i < 3 and 1 or 3
    local slime_body = require 'monster' :new {
      (i % 3 + 1) * globals.width / 4,
      j * globals.height / 4,
      species = 'slime' }
    local slime_sprite = require 'sprite' :new { sprites.slime }
    local name = 'slime' .. tostring(i)
    enemies[name] = { slime_body, slime_sprite }
    self:add_body(name, slime_body)
    self:add_drawable(name, slime_sprite)
  end
  controller:connect()
end

local function load_room (room_name)
  if not map[room_name] then
    map[room_name] = require 'room' :new { tilemap = rooms[room_name] }
  end
  if not roomdata[room_name] then
    roomdata[room_name] = { enemies = {}, items = {} }
  end
  current_room = room_name
end

function dungeon:changeroom (room_name)
  if room and room.name == room_name then return end
  load_room(room_name)
end

function dungeon:update ()
  map[current_room]:update()

  local player = self:get_body('player')
  if not player then hump.signal.emit('gameover') return end
  if player.pos.x < 0 or player.pos.x > #map[current_room].tilemap[1][1] or
     player.pos.y < 0 or player.pos.y > #map[current_room].tilemap[1] then
    if map[current_room].name == 'default' then
      self:changeroom('empty')
      player.pos:set(globals.width / 2, 1/2)
      for name, enemy in pairs(enemies) do
        self:del_body(name)
        self:del_drawable(name)
      end
      if not items.drumstick[1]:isdead() then
        self:add_body('drumstick', items.drumstick[1])
        self:add_drawable('drumstick', items.drumstick[2])
      end
    elseif map[current_room].name == 'empty' then
      self:changeroom('default')
      player.pos:set(globals.width / 2, globals.height - 1/2)
      for name, enemy in pairs(enemies) do
        if not enemy[1]:isdead() then
          self:add_body(name, enemy[1])
          self:add_drawable(name, enemy[2])
        end
      end
      self:del_body('drumstick')
      self:del_drawable('drumstick')
    end
  end

  for bname,body in pairs(self.bodies) do
    if bname ~= '__length' then
      body:update()
      for anybname, anybody in pairs(self.bodies) do
        if anybname ~= '__length' then
          if body ~= anybody then body:checkandcollide(anybody) end
        end
      end
      map[current_room]:update_collision(body)
      self:synchronize(bname)
    end
  end

  for dname, drawable in pairs(self.drawables) do
    if dname ~= '__length' then drawable:update() end
  end

  self:orderdrawables()
end

function dungeon:draw ()
  love.graphics.push()

  love.graphics.setColor(255,255,255,255)
  love.graphics.scale(globals.unit)

  map[current_room]:draw()

  for bname, body in pairs(self.bodies) do
    if bname ~= '__length' then body:draw() end
  end
  for dname, drawable in ipairs(indexed_drawables) do
    drawable:draw()
  end

  love.graphics.pop()
end

function dungeon:leave ()
  controller:disconnect()
end

function dungeon:orderdrawables ()
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

return dungeon
