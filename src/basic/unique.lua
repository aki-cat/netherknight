
local unique = require 'basic.prototype':new {
  __type = 'unique'
}

function unique:__init ()
  self.next = 0
end

function unique:generate ()
  self.next = self.next + 1
  return self.next
end

return unique:new {}
