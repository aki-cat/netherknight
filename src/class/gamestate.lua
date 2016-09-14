
local modules = orangelua.pack 'modules'

local gamestate = orangelua.prototype:new {
  __type = 'gamestate'
}

function gamestate:__init ()
  self.model = modules.model:new {}
  self.view = modules.view:new {}
end

function gamestate:__index (k)
  return getmetatable(self)[k]
end

function gamestate:update ()
  self.model:update()
  self.view:update()
end

function gamestate:draw ()
  self.model:draw()
  self.view:draw()
end

return gamestate
