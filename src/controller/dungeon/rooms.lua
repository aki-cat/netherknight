
local dungeon_rooms = module.controller:new {}

local sprites = basic.pack 'database.sprites'
local rooms_datatbase = basic.pack 'database.rooms'

local rooms = {
  [1] = require 'room' :new { tilemap = rooms_datatbase.up_right },
  [2] = require 'room' :new { tilemap = rooms_datatbase.up_left },
  [3] = require 'room' :new { tilemap = rooms_datatbase.down_left },
  [4] = require 'room' :new { tilemap = rooms_datatbase.down_right },
}

local current =  basic.vector:new { 1, 1 }

local move_room = {
  up    = basic.vector:new { -1,  0 },
  right = basic.vector:new {  0,  1 },
  down  = basic.vector:new {  1,  0 },
  left  = basic.vector:new {  0, -1 },
}

local map = {
  { 4, 3 },
  { 1, 2 },
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
      require 'monster' :new {
        globals.width / 2,
        globals.height / 4,
        species = 'eye'
      },
      require 'sprite' :new { sprites.eye }
    },
    {
      require 'collectable' :new {
        item = 'drumstick',
        globals.width / 2,
        globals.height / 2,
      },
      require 'sprite' :new { sprites.drumstick }
    },
  },
  [3] = {
    {
      require 'monster' :new {
        globals.width / 2,
        globals.height / 4,
        species = 'eye'
      },
      require 'sprite' :new { sprites.eye }
    },
    {
      require 'monster' :new {
        globals.width / 2,
        3 * globals.height / 4,
        species = 'eye'
      },
      require 'sprite' :new { sprites.eye }
    },
    {
      require 'monster' :new {
        globals.width / 4,
        globals.height / 2,
        species = 'eye'
      },
      require 'sprite' :new { sprites.eye }
    },
    {
      require 'monster' :new {
        3 * globals.width / 4,
        globals.height / 2,
        species = 'eye'
      },
      require 'sprite' :new { sprites.eye }
    },
  },
  [4] = {
    {
      require 'monster' :new {
        1 * globals.width / 4,
        love.math.random(1,3) * globals.height / 4,
        species = 'slime'
      },
      require 'sprite' :new { sprites.slime }
    },
    {
      require 'monster' :new {
        3 * globals.width / 4,
        love.math.random(1,3) * globals.height / 4,
        species = 'slime'
      },
      require 'sprite' :new { sprites.slime }
    },
  }
}

local function current_room ()
  return rooms[map[current.x][current.y]]
end

local function current_room_id ()
  return map[current.x][current.y]
end

local function load_room ()
  local room_id = current_room_id()
  for id, element in ipairs(room_elements[room_id]) do
    local entity, sprite = element[1], element[2]
    if not entity:isdead() then
      basic.signal:emit('add_entity', entity:get_type() .. tostring(entity):sub(-7), entity)
      basic.signal:emit('add_sprite', entity:get_type() .. tostring(entity):sub(-7), sprite)
    end
  end
end

function dungeon_rooms:goto_room (direction)
  current:add(move_room[direction])
  basic.signal:emit('clear_notifications')
  basic.signal:emit('clear_entities')
  load_room()
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
        local direction = false
        local newpos = basic.vector:new {}
        local roompos = current_room().pos
        if pos.x < roompos.x then
          direction = 'left'
          newpos:set(roompos.x + current_room().size.x - 1/2, roompos.y + pos.y)
        end
        if pos.x > roompos.x + current_room().size.x then
          direction = 'right'
          newpos:set( roompos.x + 1/2, roompos.y + pos.y)
        end
        if pos.y < roompos.y then
          direction = 'up'
          newpos:set(roompos.x + pos.x,roompos.y + current_room().size.y - 1/2)
        end
        if pos.y > roompos.y + current_room().size.y then
          direction = 'down'
          newpos:set(roompos.x + pos.x,roompos.y + 1/2)
        end
        if direction then
          pos:set(newpos.x, newpos.y)
          self:goto_room(direction)
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

  load_room ()
end

return dungeon_rooms:new {}
