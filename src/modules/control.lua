
local class = orangelua.pack 'class'

local control = class.object:new {
  actions = {},
  __type = 'control'
}
--[[
function control:update ()
  --self:__super().update(self)
end

function control:draw ()
  --self:__super().draw(self)
end
]]
return control
