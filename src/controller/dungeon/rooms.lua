
local dungeon_rooms = require 'controller' :new {}

local sprites = basic.pack 'database.sprites'
local rooms_datatbase = basic.pack 'database.rooms'

local rooms = {
  [1] = require 'room' :new { tilemap = rooms_datatbase.default },
  [2] = require 'room' :new { tilemap = rooms_datatbase.empty },
}

local map = {
  current = 1,
  up      = 2,
  right   = 2,
  down    = 2,
  left    = 2,
}

local room_elements = {
  [1] = {
    {
      require 'monster' :new {
        1 * globals.width  / 4,
        1 * globals.height / 4,
        species = 'slime'
      },
      require 'sprite' :new { sprites.slime }
    },
    {
      require 'monster' :new {
        3 * globals.width  / 4,
        1 * globals.height / 4,
        species = 'slime'
      },
      require 'sprite' :new { sprites.slime }
    },
    {
      require 'monster' :new {
        2 * globals.width  / 4,
        3 * globals.height / 4,
        species = 'slime'
      },
      require 'sprite' :new { sprites.slime }
    },
  },
  [2] = {
    {
      require 'collectable' :new {
        item = 'drumstick',
        globals.width  / 2,
        globals.height / 2,
      },
      require 'sprite' :new { sprites.drumstick }
    },
  }
}

local function current_room ()
  return rooms[map.current]
end

local function load_room (room_id)
  for id, elements in ipairs(room_elements) do
    for e_id,element in ipairs(elements) do
      local entity, sprite = element[1], element[2]
      if id == room_id then
        if not entity:isdead() then
          hump.signal.emit('add_entity', entity:get_type() .. tostring(e_id), entity)
          hump.signal.emit('add_sprite', entity:get_type() .. tostring(e_id), sprite)
        end
      else
        hump.signal.emit('remove_entity', entity:get_type() .. tostring(e_id))
        hump.signal.emit('remove_sprite', entity:get_type() .. tostring(e_id))
      end
    end
  end
end

function dungeon_rooms:goto_room (id)
  map.current = id
  map.up =    id % #rooms + 1
  map.down =  id % #rooms + 1
  map.left =  id % #rooms + 1
  map.right = id % #rooms + 1
  load_room(map.current)
  hump.signal.emit('clear_notifications')
end

function dungeon_rooms:update ()
  current_room():update()
end

function dungeon_rooms:draw ()
  current_room():draw()
end

function dungeon_rooms:__init ()
  self.actions = {
    {
      signal = 'check_player_position',
      func = function (pos)
        if pos.x < current_room().pos.x then
          self:goto_room(map.left)
          pos:set(
            current_room().pos.x + current_room().size.x - 1/2,
            current_room().pos.y + pos.y
          )
        end
        if pos.x > current_room().pos.x + current_room().size.x then
          self:goto_room(map.right)
          pos:set(
            current_room().pos.x + 1/2,
            current_room().pos.y + pos.y
          )
        end
        if pos.y < current_room().pos.y then
          self:goto_room(map.up)
          pos:set(
            current_room().pos.x + pos.x,
            current_room().pos.y + current_room().size.y - 1/2
          )
        end
        if pos.y > current_room().pos.y + current_room().size.y then
          self:goto_room(map.down)
          pos:set(
            current_room().pos.x + pos.x,
            current_room().pos.y + 1/2
          )
        end
      end
    },
    {
      signal = 'check_tilemap_collision',
      func = function (entity)
        current_room():check_collision(entity)
      end
    }
  }
end

return dungeon_rooms:new {}
