
local sfx = require 'controller' :new { 'audio' }

function sfx:__init ()
  local audio = self:get_model('sfx')

  -- initialise actions
  self:register_action('death', function ()
    audio:play('Die')
  end)

  self:register_action('take_damage', function (id)
    local player = self:get_distant_model('dungeon', 'player')
    if player:get_element(id) then
      audio:play('Hurt2')
    else
      audio:play('Hurt')
    end
  end)

  self:register_action('slash_attack', function (id)
    audio:play('Slash')
  end)

end

return sfx:new {}
