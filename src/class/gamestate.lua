
local modules = orangelua.pack 'modules'

local gamestate = orangelua.prototype:new {
  __type = 'gamestate'
}

function gamestate:__init()
  self.model = modules.model:new {}
  self.view = modules.view:new {}
end

function gamestate:update (args)
  self.model:update()
  self.view:update()
end

function gamestate:draw (args)
  self.model:draw()
  self.view:draw()
end

return gamestate
