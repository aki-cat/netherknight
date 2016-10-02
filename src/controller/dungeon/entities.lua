
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
      basic.signal:emit('check_tilemap_collision', entity)
      basic.signal:emit('update_position', name, entity.pos)
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
          print('add entity:', name)
          entities[name] = entity
        end
      end
    },
    {
      signal = 'remove_entity',
      func = function (name)
        entities[name] = nil
        basic.signal:emit('remove_sprite', name)
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
          basic.signal:emit('remove_entity', name)
          print("DEATH:", name)
        end
      end
    },
    {
      signal = 'entity_immunity',
      func = function (entity, time)
        local name = find_entity(entity)
        if name then
          basic.signal:emit('shine_sprite', name, time or globals.stagger)
        end
      end
    },
    {
      signal = 'entity_turn',
      func = function (entity, dir)
        local name = find_entity(entity)
        if name then
          if dir == 'left' or dir == 'up_left' or dir == 'down_left' then
            basic.signal:emit('flip_horizontal', name, false)
          elseif dir == 'right' or dir == 'up_right' or dir == 'down_right' then
            basic.signal:emit('flip_horizontal', name, true)
          end
        end
      end
    },
    {
      signal = 'drop_money',
      func = function (strength, pos)
        -- 50% chance of dropping money or nothing
        local quantity
        if love.math.random() < .75 then
          local droplvl = love.math.random()
          if droplvl < .5 then
            quantity = 1
          elseif droplvl < .75 then
            quantity = 5
          elseif droplvl < .85 and strength > 30 then
            quantity = 20
          elseif droplvl < .90 and strength > 30 then
            quantity = 50
          end
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
            basic.signal:emit('remove_entity', name)
          end
        end
      end
    },
    {
      signal = 'entity_slain',
      func = function (entity)
        local name = find_entity(entity)
        basic.signal:emit('freeze_animation', name)
        basic.signal:emit('turn_white', name)
      end
    },
    {
      signal = 'take_damage',
      func = function (entity, dmg)
        if entity:get_type() == 'player' then
          audio:playSFX('Hurt2')
        elseif entity:get_type() == 'monster' then
          audio:playSFX('Hurt')
        end
        module.notification:new { 'damage', entity.pos.x, entity.pos.y, value = dmg }
      end
    },
  }
end

return dungeon_entities:new {}
