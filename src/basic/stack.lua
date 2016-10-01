
local stack = require 'basic.prototype' :new {
  __type = 'stack'
}

function stack:__init ()
  self.stack = {}
  self.head = 0
end

function stack:push (item)
  self.stack[self.head] = item
  self.head = self.head + 1
end

function stack:pop ()
  local item = self.stack[self.head]
  self.stack[self.head] = nil
  self.head = self.head - 1
  return item
end

function stack:__index (k)
  return getmetatable(self)[k]
end

return stack
