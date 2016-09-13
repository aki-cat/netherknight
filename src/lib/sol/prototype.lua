
local prototype = {}
prototype.__index = prototype
prototype.__type = 'prototype'

local function recursive_construct(obj, super)
  if not super then return end
  recursive_construct(super, super:__super())
  if super.__construct and type(super.__construct) == 'function' then
    super.__construct(obj)
  end
end

function prototype:new(object)
  object = object or {}
  object.__index = self.__index
  setmetatable(object, self)
  recursive_construct(object, self)
  return object
end

function prototype:__super()
  return getmetatable(self)
end

return prototype
