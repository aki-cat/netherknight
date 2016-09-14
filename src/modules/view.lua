
local class = orangelua.pack 'class'

local view = class.object:new {
  __type = 'view'
}

function view:update ()
  self:__super().update(self)
end

function view:draw ()
  self:__super().draw(self)
end

return view
