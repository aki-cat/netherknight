
local pool = {}

-- find
function pool.find (t, val)
  for k, obj in pairs(t) do
    if obj == val then return k end
  end
end

-- add
function pool.add (t, item)
  table.insert(t, item)
end

-- remove
function pool.remove (t, k)
  local N = #t
  t[k] = nil
  t[k] = t[N]
  t[N] = nil
end

return pool
