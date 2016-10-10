
local player = require 'controller' :new { 'dungeon' }

function player:__init ()
  local physics_util = require 'basic.physics'
  local player_model = self:get_model('player')

  -- initialise actions
  self:register_action('death', function (id)
    player_model:remove_element(id)
    local DEATH_TIME = 0.6
    self.timer:after(DEATH_TIME, function ()
      signal.broadcast('gameover')
    end)
  end)

  self:register_action('hold_direction', function (dirname)
    local player_element = player_model:get_player()
    if not player_element or player_element:is_locked() then return end

    local id = player_element:get_id()
    if dirname ~= 'none' then
      local movement = physics_util.get_direction(dirname)
      local speed = 1/globals.unit * 1/2
      signal.broadcast('move', id, movement * speed)
      signal.broadcast('change_state', id, 'walking')
    else
      signal.broadcast('change_state', id, 'default')
    end
  end)

  self:register_action('press_action', function (action)
    if action == 'quit' then
      print("QUIT GAME")
      love.event.quit()
    elseif action == 'maru' then
      local player_element = player_model:get_player()
      local id = player_element:get_id()
      if not player_element or player_element:is_locked() then return end
      
      signal.broadcast('slash_attack', id)
      signal.broadcast('change_state', id, 'attack')
      player_element:lock(.2)
    end
  end)
end

return player:new {}
