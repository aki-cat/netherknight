
local signal = require 'basic.prototype' :new {
  __type = 'signal'
}

function signal:__init ()
  self.listeners = {}
  self.queue = require 'basic.queue' :new { 2^10 }
end

function signal:register (n, f)
  assert(type(n) == 'string', "Signal name must be a string")
  assert(f, "Must register handle to a signal")
  if not self.listeners[n] then self.listeners[n] = {} end
  self.listeners[n][f] = f
  return f -- return handle for removal
end

function signal:emit (n, ...)
  assert(type(n) == 'string', "Signal name must be a string")
  if self.listeners[n] then
    for f in pairs(self.listeners[n]) do
      f(...)
    end
  end
end

function signal:queue (n, ...)
  self.queue:enqueue { n, ... }
end

function signal:update ()
  self.queue:enqueue(-1)
  local s = self.queue:dequeue()
  while s ~= -1 do
    self:emit(unpack(s))
    s = self.queue:dequeue()
  end
end

function signal:remove (n, f)
  assert(type(n) == 'string', "Signal name must be a string")
  assert(f, "Must pass handle to erase")
  if self.listeners[n] then
    self.listeners[n][f] = nil
  end
end

function signal:clear (n)
  assert(type(n) == 'string', "Signal name must be a string")
  self.listeners[n] = nil
end

return signal:new {}
