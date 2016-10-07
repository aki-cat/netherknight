
local map = basic.prototype:new {
  9,
  __type = 'map'
}

local dirs = {
  basic.vector:new {  0,  1 }, -- up
  basic.vector:new {  1,  0 }, -- right
  basic.vector:new {  0, -1 }, -- down
  basic.vector:new { -1,  0 }, -- left
}

function map:generate (size)
  while #self.rooms < size do
    -- select random room
    local k = math.random(1, #self.rooms)
    local room = self.rooms[k]
    local connectable = false

    -- check for empty connections
    for direction, connection in ipairs(room.connections) do
      if connection == 0 then
        connectable = true
      end
    end

    -- if there are any then...
    if connectable then
      -- create new room
      local newroom = self:add_room(math.random(12, 15), math.random(6, 9))

      -- get random distance
      local dir = math.random(1,4)
      while room.connections[dir] ~= 0 do dir = math.random(1,4) end

      -- connect rooms
      print('connect room '.. k ..' to '.. #self.rooms ..' by ' .. dir)
      room:connect(dir, newroom)
      dir = (dir + 5) % 4 + 1
      print('connect room '.. #self.rooms ..' to '.. k ..' by ' .. dir)
      newroom:connect(dir, room)
      print('new room!')
    end
  end
end

function map:add_room (width, height)
  local room = require 'room.generator' :new { width, height }
  table.insert(self.rooms, room)
  return room
end

function map:get_room (id)
  return self.rooms[id]
end

function map:__init ()
  self.rooms = {}
  local firstroom = self:add_room(12, 6)
  firstroom.connections[1] = 1 -- dont connect upward!
  self:generate(self[1])
  for k,v in ipairs(self.rooms) do
    print("room #"..k)
    print(v)
  end
end

return map
