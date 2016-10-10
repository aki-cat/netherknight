
local actors = require 'controller' :new { 'dungeon' }

function actors:__init ()
  local actors_model = self:get_model('actors')

  -- initialise actions
  self:register_action('death', function (id)
    actors_model:remove_element(id)
  end)

  self:register_action('collision', function (id1, id2)
    local a1 = actors_model:get_element(id1)
    local a2 = actors_model:get_element(id2)
    if not a1 or not a2 then return end
    if a1:get_harm_level() > a2:get_harm_level() then
      a2:take_damage(a1)
    elseif a1:get_harm_level() < a2:get_harm_level() then
      a1:take_damage(a2)
    end
  end)

end

return actors:new {}
