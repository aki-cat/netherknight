
local prototype = {}
--prototype.__index = prototype
prototype.__type = 'prototype'

local function recursive_construct (obj, super)
  if not super then return end
  recursive_construct(obj, super:__super())
  if super.__init and type(super.__init) == 'function' then
    super.__init(obj)
  end
end

function prototype:new (object)
  object = object or {}
  object.__index = object
  setmetatable(object, self)
  recursive_construct(object, self)
  return object
end

function prototype:clone ()
  local clone = {}
  for k,v in pairs(self) do
    if k ~= "__index" then
      if type(v) ~= 'table' then
        clone[k] = v
      else
        local t = prototype.clone(v)
        clone[k] = t
      end
    end
  end
  setmetatable(clone, getmetatable(self))
  return clone
end

function prototype:get_type (args)
  return self.__type
end

function prototype:__super ()
  return getmetatable(self)
end

function prototype:__index (k)
  return getmetatable(self)[k]
end

return prototype
