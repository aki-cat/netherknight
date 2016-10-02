
local dungeon_rooms = module.controller:new {}

-- dependencies
local sprites = basic.pack 'database.sprites'

-- define no of rooms
local dungeon_size = 9

-- generate map with n rooms
local map = require 'map' :new { dungeon_size }

-- room data
local current_room, walls, tilemap
local room_elements = {}

-- randomly generates room elements
local function new_room_elements (room)
  local elements = {}
  local walkable_space = room:get_walkable_tiles()
  local room_type = math.random(1,6)
  print("random room:", room_type)
  if room_type == 1 then
    -- three slime room
    for i = 1, 3 do
      local k = math.random(1, #walkable_space)
      local pos = basic.table.take(walkable_space, k)
      local e = {
        module.monster:new { pos.x, pos.y, species = 'slime' },
        module.sprite:new { sprites.slime },
      }
      elements[i] = e
    end
  elseif room_type == 2 then
    -- 5 slime room
    for i = 1, 5 do
      local k = math.random(1, #walkable_space)
      local pos = basic.table.take(walkable_space, k)
      local e = {
        module.monster:new { pos.x, pos.y, species = 'slime' },
        module.sprite:new { sprites.slime },
      }
      elements[i] = e
    end
  elseif room_type == 3 then
    -- 1 eye and 1 drumstick room
    for i = 1, 2 do
      local k = math.random(1, #walkable_space)
      local pos = basic.table.take(walkable_space, k)
      local e
      if i == 1 then
        e = {
          module.monster:new { pos.x, pos.y, species = 'eye' },
          module.sprite:new { sprites.eye },
        }
      else
        e = {
          module.collectable:new { pos.x, pos.y, item = 'drumstick' },
          module.sprite:new { sprites.drumstick },
        }
      end
      elements[i] = e
    end
  elseif room_type == 4 then
    -- 3 eye and 1 drumstick room
    for i = 1, 4 do
      local k = math.random(1, #walkable_space)
      local pos = basic.table.take(walkable_space, k)
      local e
      if i > 1 then
        e = {
          module.monster:new { pos.x, pos.y, species = 'eye' },
          module.sprite:new { sprites.eye },
        }
      else
        e = {
          module.collectable:new { pos.x, pos.y, item = 'drumstick' },
          module.sprite:new { sprites.drumstick },
        }
      end
      elements[i] = e
    end
  elseif room_type == 5 then
    -- 4 eye room
    for i = 1, 4 do
      local k = math.random(1, #walkable_space)
      local pos = basic.table.take(walkable_space, k)
      local e = {
        module.monster:new { pos.x, pos.y, species = 'eye' },
        module.sprite:new { sprites.eye },
      }
      elements[i] = e
    end
  elseif room_type == 6 then
    -- drumstick only room
    local k = math.random(1, #walkable_space)
    local pos = basic.table.take(walkable_space, k)
    local e = {
      module.collectable:new { pos.x, pos.y, item = 'drumstick' },
      module.sprite:new { sprites.drumstick },
    }
    elements[1] = e
  end
  return elements
end

-- loads room elements
function load_room_elements (room)
  if not room_elements[room] then
    room_elements[room] = new_room_elements(room)
  end
  for _,element in ipairs(room_elements[room]) do
    local entity, sprite = element[1], element[2]
    if not entity:isdead() then
      basic.signal:emit('add_entity', entity:get_type() .. tostring(entity):sub(-7), entity)
      basic.signal:emit('add_sprite', entity:get_type() .. tostring(entity):sub(-7), sprite)
    end
  end
end

-- get first room data
local function load_room(room)
  basic.signal:emit('clear_notifications')
  basic.signal:emit('clear_entities')
  current_room = room
  walls, tilemap = current_room:deploy('default')
  load_room_elements(current_room)
end

function dungeon_rooms:update ()
  --tilemap:update()
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
        if pos.y < current_room.margin - 2 then
          local nextroom = current_room.connections[1]
          if nextroom ~= 0 then load_room(nextroom) end
          pos:set(nextroom.spawn[3]:unpack())
        elseif pos.x > current_room.margin + current_room.width + 2 then
          local nextroom = current_room.connections[2]
          if nextroom ~= 0 then load_room(nextroom) end
          pos:set(nextroom.spawn[4]:unpack())
        elseif pos.y > current_room.margin + current_room.height + 2 then
          local nextroom = current_room.connections[3]
          if nextroom ~= 0 then load_room(nextroom) end
          pos:set(nextroom.spawn[1]:unpack())
        elseif pos.x < current_room.margin - 2 then
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
    },
    {
      signal = 'set_player_in_room',
      func = function (player)
        local walkable_space = current_room:get_walkable_tiles()
        local k = math.random(1, #walkable_space)
        local pos = basic.table.take(walkable_space, k)
        player.pos:set(pos:unpack())
      end
    }
  }
  -- start first room
  load_room(map:get_room(1))
end

return dungeon_rooms:new {}
