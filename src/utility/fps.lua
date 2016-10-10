
local fps = require 'basic.prototype' :new {}

function fps:__init ()
  self.fps = 0
  self.dtcount = 0
  self.framecount = 0
end

function fps:tick ()
  self.framecount = self.framecount + 1
end

function fps:update (dt)
  self.dtcount = self.dtcount + dt
  if self.dtcount >= 1 then
    self.dtcount = 0
    self.fps = self.framecount
    self.framecount = 0
  end
end

return fps
