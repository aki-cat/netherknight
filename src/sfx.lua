
local sfx = basic.prototype:new {
  'Ok.wav',
  __type = 'sfx'
}

local SFX_POOL_SIZE = 5

function sfx:__init ()
  self.pool = {}
  self.index = 5
  for i = 1, SFX_POOL_SIZE do
    table.insert(self.pool, love.audio.newSource( 'assets/sfx/' .. self[1], 'static'))
  end
end

function sfx:play()
  self.index = (self.index % SFX_POOL_SIZE) + 1
  love.audio.stop(self.pool[self.index])
  love.audio.play(self.pool[self.index])
end

return sfx
