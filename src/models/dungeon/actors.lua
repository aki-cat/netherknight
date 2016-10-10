
local actors = require 'model' :new {}

function actors:update ()
  local pool = self:get_pool()
  local deathlist = {}
  for index, actor in ipairs(pool) do
    if actor:is_dead() then
      table.insert(deathlist, actor:get_id())
      signal.broadcast('death', actor:get_id())
    else
      actor:update()
    end
  end
  for i = 1, #deathlist do
    self:remove_element(deathlist[i])
  end
end

return actors:new {}
