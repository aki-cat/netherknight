
local dungeon_entities = module.controller:new {}

local dungeon = hump.gamestate.current()
local entities = {}

local function other(t, index)
  return function(s, var)
    var = next(s, var)
    return var, s[var]
  end, t, index
end

function dungeon_entities:update ()
  for name, entity in pairs(entities) do
    if dungeon:getcamera():valid_entity(entity) then
      for bname, body in other(entities, name) do
        entity:check_collision_by_axis(body)
      end
      entity:update()
      hump.signal.emit('check_tilemap_collision', entity)
      hump.signal.emit('update_position', name, entity.pos)
    end
  end
end

function dungeon_entities:draw ()
  for name, entity in pairs(entities) do
    if dungeon:getcamera():valid_entity(entity) then
      entity:draw()
    end
  end
end

function dungeon_entities:get (name)
  return entities[name]
end

local function find_entity (entity)
  for name, e in pairs(entities) do
    if entity == e then return name end
  end
end

function dungeon_entities:__init ()
  self.actions = {
    {
      signal = 'add_entity',
      func = function (name, entity)
        if entities[name] then
          return error("Can't add second entity " .. name)
        end
        if not entity:isdead() then
          entities[name] = entity
        end
      end
    },
    {
      signal = 'remove_entity',
      func = function (name)
        entities[name] = nil
        hump.signal.emit('remove_sprite', name)
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
      func = function (entity)
        local name = find_entity(entity)
        if name then
          hump.signal.emit('remove_entity', name)
          print("DEATH:", name)
        end
      end
    },
    {
      signal = 'entity_immunity',
      func = function (entity, time)
        local name = find_entity(entity)
        if name then
          hump.signal.emit('shine_sprite', name, time or globals.stagger)
        end
      end
    },
    {
      signal = 'entity_turn',
      func = function (entity, dir)
        local name = find_entity(entity)
        if name then
          if dir == 'left' or dir == 'up_left' or dir == 'down_left' then
            hump.signal.emit('flip_horizontal', name, false)
          elseif dir == 'right' or dir == 'up_right' or dir == 'down_right' then
            hump.signal.emit('flip_horizontal', name, true)
          end
        end
      end
    },
    {
      signal = 'drop_money',
      func = function (strength, pos)
        -- 50% chance of dropping money or nothing
        local quantity
        if love.math.random() > .2 then
          quantity = math.floor(strength + 1.05 ^ gamedata.level * (0.5 + love.math.random()))
        end
        if quantity then
          local drop = module.money:new {
            pos.x,
            pos.y,
            ammount = quantity }
          drop:drop()
        end
      end
    },
    {
      signal = 'clear_entities',
      func = function ()
        for name, entity in pairs(entities) do
          if name ~= 'player' then
            hump.signal.emit('remove_entity', name)
          end
        end
      end
    },
    {
      signal = 'entity_slain',
      func = function (entity)
        local name = find_entity(entity)
        hump.signal.emit('freeze_animation', name)
        hump.signal.emit('turn_white', name)
      end
    },
    {
      signal = 'take_damage',
      func = function (entity, dmg)
        if entity:get_type() == 'player' then
          audio:playSFX('Hurt2')
          dmg = dmg * gamedata.level
        elseif entity:get_type() == 'monster' then
          audio:playSFX('Hurt')
          dmg = math.floor( 1 + .5 + dmg * 1.25 ^ gamedata.level * (0.75 + love.math.random() * 0.5) )
        end
        module.notification:new { 'damage', entity.pos.x, entity.pos.y, value = dmg }
      end
    },
  }
end

return dungeon_entities:new {}
