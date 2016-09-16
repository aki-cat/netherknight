
local monster = require 'body' :new {
  behaviour = function(self) end,
  state = 1,
  __type = 'monster'
}

function monster:__init ()
end

function monster:choose (st)
  self.state = st
end

function monster:think ()
  self:behaviour()
end

return monster
