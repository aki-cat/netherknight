
local object = orangelua.prototype:new {
  parent = false,
  children = {},
  __type = 'object'
}

function object:__init()
  print(self.__type)
end

function object:__index (k)
  return getmetatable(self)[k]
end

function object:__newindex (k, v)
  if k == 'parent' then return
  elseif k == 'children' then return
  else rawset(self, k, v) end
end

local function setparent (child, parent)
  rawset(child, 'parent', parent)
end

local function recursive_find (parent, child)
  if not parent.children then return end
  for _,subchild in pairs(parent.children) do
    if subchild == child then return child end
    recursive_find(subchild,child)
  end
end

function object:addchild (child)
  if recursive_find(self, child) then
    return error 'Child object is already in the tree.'
  end
  table.insert(self.children, child)
  setparent(child, self)
end

function object:update()
  for k,child in pairs(self.children) do
    child:update()
  end
end

function object:draw()
  for k,child in pairs(self.children) do
    child:draw()
  end
end

return object
