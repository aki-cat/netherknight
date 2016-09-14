
local class = orangelua.pack 'class'

local physics = class.object:new {
  __type = 'physics'
}
--[[
function physics:update ()
  --self:__super().update(self)
end

function physics:draw ()
  --self:__super().draw(self)
end
]]
return physics
