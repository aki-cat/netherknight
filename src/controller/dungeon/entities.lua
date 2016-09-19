
local dungeon_entities = require 'controller' :new {}

local dungeon = hump.gamestate.current()
local entities = {}
local roomtiles = {}

local function other(t, index)
  return function(s, var)
    var = next(s, var)
    return var, s[var]
  end, t, index
end

function dungeon_entities:update()
  for name, entity in pairs(entities) do
    entity:update()
    for bname, body in other(entities, name) do
      entity:checkandcollide(body)
    end
    for i, tile in pairs(roomtiles) do
      entity:checkandcollide(tile)
    end
    hump.signal.emit('update_position', name, entity.pos)
  end
end

function dungeon_entities:draw()
  for name, entity in pairs(entities) do
    entity:draw()
  end
end

function dungeon_entities:get (name)
  return entities[name]
end

function dungeon_entities:__init ()
  self.actions = {
    {
      signal = 'add_entity',
      func = function(name, entity)
        assert(entities[name], "Can't add second " .. name)
        entities[name] = entity
      end
    },
    {
      signal = 'remove_entity',
      func = function(name)
        entities[name] = nil
        hump.signal.emit('remove_sprite', name)
      end
    },
    {
      signal = 'addtile',
      func = function(tile)
        table.insert(roomtiles, tile)
      end
    },
    {
      signal = 'cleartiles',
      func = function()
        for i, tile in ipairs(roomtiles) do roomtiles[i] = nil end
      end
    },
    {
      signal = 'entity_collision',
      func = function (entity, somebody)
        entity:on_collision(somebody)
      end
    },
    {
      signal = 'entity_death',
      func = function(entity)
        local name = dungeon:find_entity(entity)
        if name then
          dungeon:del_entity(entity)
          dungeon:del_sprite(name)
          print("DEATH:", bodyname)
        end
      end
    },
    {
      signal = 'entity_immunity',
      func = function(body, immune)
        local scene = hump.gamestate.current()
        local name = scene:find_body(body)
        local sprite = scene:get_sprite(name)
        local shine = immune and 40 or 0
        if name and sprite then sprite.shine = shine end
      end
    },
  }
end

return dungeon_entities:new {}
