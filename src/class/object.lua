
local object = lib.sol.prototype:new{
  __type = 'object'
}

function object:__init()
  print(self.__type)
end

function object:update()
  -- do stuff
end

function object:render()
  -- draw stuff
end

return object
