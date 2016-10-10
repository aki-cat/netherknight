
local sfx = require 'element' :new {
  'Ok.wav',
  poolsize = 3,
  __type = 'sfx'
}

function sfx:__init ()
  self.pool = {}
  self.index = 1
  for i = 1, self.poolsize do
    table.insert(self.pool, love.audio.newSource( 'assets/sfx/' .. self[1], 'static'))
  end
end

function sfx:play()
  self.index = (self.index % self.poolsize) + 1
  --love.audio.stop(self.pool[self.index])
  love.audio.play(self.pool[self.index])
end

return sfx
