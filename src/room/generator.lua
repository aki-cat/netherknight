
local room = basic.prototype:new {
  16, 10, 0,
  __type = 'room'
}

local margin = 10

local directions = {
  [1] = 'up',
  [2] = 'right',
  [3] = 'down',
  [4] = 'left',
}

function room:__init ()
  self.margin = margin
  self.width, self.height = self[1], self[2]
  self.tilemap = basic.matrix:new { self[1] + self.margin * 2, self[2] + self.margin * 2, self[3] }
  self.connections = { 0, 0, 0, 0 }
  self.spawn = { 0, 0, 0, 0 }
  self:generate()
end

function room:generate ()
  -- currently generates empty by default
  for i, j, tile in self.tilemap:iterate() do
    if i <= self.margin or
       j <= self.margin or
       i > self.tilemap:get_height() - self.margin or
       j > self.tilemap:get_width() - self.margin then
      self.tilemap:set(i, j, 2)
    else
      self.tilemap:set(i, j, 1)
    end
  end
  self:filter()
end

function room:filter ()
  local patterns = require 'database.tilesets.patterns'
  local action_queue = {}
  -- first we find patterns in the tiles
  for _,pattern in ipairs(patterns) do
    local list = patterns.from_pattern_to_action(self.tilemap, pattern)
    for _,action in ipairs(list) do
      table.insert(action_queue, action)
    end
  end
  -- then we resolve the patterns' matches results
  for _,action in ipairs(action_queue) do
    self.tilemap:set(action[1], action[2], action[3])
  end
end

function room:get_side(side, offset)
  local sides = {
    [1] = basic.vector:new { self.margin + offset, self.margin },
    [2] = basic.vector:new { self.margin + self.width + 1, self.margin + offset },
    [3] = basic.vector:new { self.margin + offset, self.margin + self.height + 1 },
    [4] = basic.vector:new { self.margin, self.margin + offset },
  }
  return sides[side]
end

function room:set_spawn_point (side, offset)
  self.spawn[side] = self:get_side(side, offset)
  if side % 2 == 1 then
    self.spawn[side]:add { 0, -1/2, 0 }
  else
    self.spawn[side]:add { -1/2, 0, 0 }
  end
  print("new spawn point: ", self.spawn[side]:unpack())
end

function room:open (side, offset)
  local starti, startj, endi, endj = 0, 0, 0, 0
  if side % 2 == 1 then
    -- if up or down, offset is horizontal
    while offset >= self.width do offset = offset - 1 end
    starti = -1
    endi = 1
    startj = 0
    endj = 1
  else
    -- if left or right, offset is vertical
    while offset >= self.height do offset = offset - 1 end
    starti = 0
    endi = 1
    startj = -1
    endj = 1
  end
  local pos = self:get_side(side, offset)
  for di = pos.i + starti, pos.i + endi do
    for dj = pos.j + startj, pos.j + endj do
      self.tilemap:set(di, dj, 1)
    end
  end
  self:set_spawn_point(side, offset)
  self:filter()
end

function room:connect (dir, r)
  if dir >= 1 and dir <= 4 then
    self.connections[dir] = r
    if dir % 2 == 0 then
      self:open(dir, math.random(1, self.height))
    else
      self:open(dir, math.random(1, self.width))
    end
  end
end

function room:deploy (tileset)
  local rooms = basic.pack 'rooms'
  local walls = require 'room.walls' :new { self.tilemap }
  local tilemap = require 'room.tilemap' :new { tileset, self.tilemap }
  return walls, tilemap
end

function room:__tostring ()
  local str = ''
  for i, row in self.tilemap:iteraterows() do
    local s = '['
    for j, tile in ipairs(row) do
      if tile == 1 then
        s = s .. ' '
      else
        s = s .. '#'
      end
      --s = s .. tile
      s = s .. ' '
    end
    s = s .. ']\n'
    str = str .. s
  end
  return str
end

return room
