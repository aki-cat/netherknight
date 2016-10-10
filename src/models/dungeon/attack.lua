
local attack = require 'model' :new {}

function attack:update ()
  local pool = self:get_pool()
  for index, atk in ipairs(pool) do
    atk:update()
    if atk:is_done() then
      self:remove_element(atk:get_id())
      signal.broadcast('done', atk:get_id())
    end
  end
end

return attack:new {}
