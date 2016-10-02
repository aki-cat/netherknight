
local dungeon_rooms = module.controller:new {}

-- generate map with n rooms
local map = require 'map' :new { 9 }

-- room data
local current_room, walls, tilemap

-- get first room data
local function load_room(id)
  current_room = map:get_room(id) or id
  print('going to room: ')
  print(current_room)
  walls, tilemap = current_room:deploy('default')
end

function dungeon_rooms:update ()
  tilemap:update()
end

function dungeon_rooms:draw ()
  love.graphics.push()
  love.graphics.scale(1/globals.unit)
  tilemap:draw()
  love.graphics.pop()
end

function dungeon_rooms:__init ()
  self.actions = {
    {
      signal = 'check_player_position',
      func = function (pos)
        local room = map:get_room(room_id)
        if pos.y < current_room.margin - 1/2 then
          local nextroom = current_room.connections[1]
          if nextroom ~= 0 then load_room(nextroom) end
          pos:set(nextroom.spawn[3]:unpack())
        elseif pos.x > current_room.margin + current_room.width + 1/2 then
          local nextroom = current_room.connections[2]
          if nextroom ~= 0 then load_room(nextroom) end
          pos:set(nextroom.spawn[4]:unpack())
        elseif pos.y > current_room.margin + current_room.height + 1/2 then
          local nextroom = current_room.connections[3]
          if nextroom ~= 0 then load_room(nextroom) end
          pos:set(nextroom.spawn[1]:unpack())
        elseif pos.x < current_room.margin - 1/2 then
          local nextroom = current_room.connections[4]
          if nextroom ~= 0 then load_room(nextroom) end
          pos:set(nextroom.spawn[2]:unpack())
        end
      end
    },
    {
      signal = 'check_tilemap_collision',
      func = function (entity)
        if walls then walls:update_collisions(entity) end
      end
    }
  }
  -- start first room
  load_room(1)
end

return dungeon_rooms:new {}
