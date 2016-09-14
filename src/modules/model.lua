
local class = orangelua.pack 'class'

local model = class.object:new {
  __type = 'model'
}

function model:update ()
  self:__super().update(self)
end

function model:draw ()
  self:__super().draw(self)
end

return model
