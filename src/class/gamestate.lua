
local modules = orangelua.pack 'modules'

local gamestate = orangelua.prototype:new {
  __type = 'gamestate'
}

function gamestate:__init ()
  self.control = modules.control:new {}
  self.physics = modules.physics:new {}
  self.display = modules.display:new {}
end

function gamestate:__index (k)
  return getmetatable(self)[k]
end

function gamestate:update ()
  self.control:update()
  self.physics:update()
  self.display:update()
end

function gamestate:draw ()
  self.control:draw()
  self.physics:draw()
  self.display:draw()
end

return gamestate
