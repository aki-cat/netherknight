
local vector = orangelua.prototype:new {
  0,
  0,
  0,
  __type = 'vector'
}

function vector:__index (k)
  if k == 'x' then return self[1] end
  if k == 'y' then return self[2] end
  if k == 'z' then return self[3] end
  return vector[k]
end

function vector:__newindex (k, v)
  if     k == 'x' then rawset(self, 1, v)
  elseif k == 'y' then rawset(self, 2, v)
  elseif k == 'z' then rawset(self, 3, v)
  else rawset(self, k, v) end
end

function vector:__add (l, r)
  return vector:new{
    l[1] + r[1],
    l[2] + r[2],
    l[3] + r[3]
  }
end

function vector:__sub (l, r)
  return vector:new{
    l[1] - r[1],
    l[2] - r[2],
    l[3] - r[3]
  }
end

local function scalar_product (v, f)
  return vector:new{
    f * v[1],
    f * v[2],
    f * v[3]
  }
end

function vector:__mul (l, r)
  if type(l) == 'number' then
    scalar_product(r, l)
  elseif type(r) == 'number' then
    scalar_product(l, r)
  else
    return vector:new{
      l[1] * r[1],
      l[2] * r[2],
      l[3] * r[3]
    }
  end
end

function vector:__div (l, r)
  if type(r) == 'number' then
    scalar_product(l, 1.0/r)
  else
    return error "Can't divide " .. type(l) .. " by " .. type(r) .. "."
  end
end

function vector:set (x, y, z)
  self[1] = x or 0
  self[2] = y or 0
  self[3] = z or 0
end

function vector:unpack ()
  return self[1], self[2], self[3]
end

function vector:size()
  return math.sqrt( self * self )
end

function vector:normalized ()
  return self/self:size()
end

function vector:add (v)
  self[1] = self[1] + v[1]
  self[2] = self[2] + v[2]
  self[3] = self[3] + v[3]
end

function vector:sub (v)
  self[1] = self[1] - v[1]
  self[2] = self[2] - v[2]
  self[3] = self[3] - v[3]
end

function vector:mul (f)
  self[1] = self[1] * f
  self[2] = self[2] * f
  self[3] = self[3] * f
end

return vector
