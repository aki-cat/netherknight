
local t = {}

function t:take (k)
  local N = #self
  local item = self[k]
  self[k] = self[N]
  self[N] = nil
  return item
end

return t
