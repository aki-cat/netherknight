
local class = orangelua.pack 'class'

local object2d = class.object:new {
  __type = 'object2d'
}

function object2d:__init ()
  print('object2d init')
  self.pos = class.vector:new {}
end

function object2d:setpos (x, y, z)
  print('set pos!', x, y, z)
  self.pos:set(x, y, z)
  print('set pos!', self.pos:unpack())
end

function object2d:getpos ()
  return self.pos
end

return object2d
