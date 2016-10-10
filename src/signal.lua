
local signal = {}

local receivers = {}

function signal.broadcast (name, ...)
  for _,receiver in ipairs(receivers) do
    receiver:execute(name, ...)
  end
end

function signal.connect (r)
  local pool = require 'basic.pool'
  pool.add(receivers, r)
end

function signal.disconnect (r)
  local pool = require 'basic.pool'
  local i = pool.find(receivers, r)
  pool.remove(receivers, i)
end

return signal
