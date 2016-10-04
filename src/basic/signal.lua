
local signal = require 'basic.prototype' :new {
  __type = 'signal'
}

function signal:__init ()
  self.signals = {}
  self.queue = require 'basic.queue' :new { 2^10 }
end

function signal:register (n, f)
  assert(type(n) == 'string', "Signal name must be a string")
  assert(f, "Must register handle to a signal")
  if not self.signals[n] then self.signals[n] = {} end
  self.signals[n][f] = f
  return f -- return handle for removal
end

function signal:emit (n, ...)
  assert(type(n) == 'string', "Signal name must be a string")
  if self.signals[n] then
    for f in pairs(self.signals[n]) do
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
  if self.signals[n] then
    self.signals[n][f] = nil
  end
end

function signal:clear (n)
  assert(type(n) == 'string', "Signal name must be a string")
  self.signals[n] = nil
end

return signal:new {}
