
local behaviours = require 'model' :new {}

function behaviours:update ()
  local pool = self:get_pool()
  for index, behaviour in ipairs(pool) do
    behaviour:update()
  end
end

return behaviours:new {}
