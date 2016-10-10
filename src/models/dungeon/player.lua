
local player = require 'model' :new {}

function player:update ()
  local pool = self:get_pool()
  for index, player in ipairs(pool) do
    player:update()
  end
end

function player:get_player ()
  return self:get_pool()[1]
end

return player:new {}
