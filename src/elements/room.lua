
local roomgen = require 'roomgen'
local vector = require 'basic.vector'

local room = require 'element' :new {
  16, 10, 2,
  __type = 'room'
}

function room:__init ()
  self.pos = vector:new {}
  self.width = self[1]
  self.height = self[2]
  self.margin = self[3]
  self.tilemap = roomgen.generate(self.width, self.height, self.margin)
  self.collision_map = roomgen.get_collision_map(self.tilemap)
  roomgen.filter(self.tilemap)
  print(self)
end

function room:get_width ()
  return self.width
end

function room:get_height ()
  return self.height
end

function room:get_margin ()
  return self.margin
end

function room:get_tilemap ()
  return self.tilemap
end

function room:get_collision_map ()
  return self.collision_map
end

function room:get_walkable_tiles ()
  local walkables = {}
  for i, j, tile in self.tilemap:iterate() do
    if i > self.margin and i <= self.margin + self.height then
      if j > self.margin and i <= self.margin + self.width then
        if tile == 1 then table.insert(walkables, vector:new {j - 1/2, i - 1/2}) end
      end
    end
  end
  return walkables
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
