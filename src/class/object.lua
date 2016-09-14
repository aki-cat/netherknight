
local object = orangelua.prototype:new {
  __type = 'object'
}

function object:__init()
  print('object init')
  self.name = 'object'
  rawset(self, 'parent', false)
  rawset(self, 'children', {})
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

function object:addchild (child)
  for k,subchild in pairs(self.children) do
    if subchild == child then
      return error 'Child object is already in place.'
    end
  end
  table.insert(self.children, child)
  setparent(child, self)
end

function object:remchild (child)
  for k,subchild in pairs(self.children) do
    if subchild == child then
      self.children[k] = nil
      setparent(child, false)
    end
  end
end

function object:getchild (name)
  for k,child in pairs(self.children) do
    if child.name == name then
      return child
    end
  end
end

function object:__update ()
  -- reimplement this function in every object that inherits from this class
end

function object:__draw ()
  -- reimplement this function in every object that inherits from this class
end

function object:update ()
  for k,child in pairs(self.children) do
    child:update() -- ascending recursion
    child:__update()
  end
  self:__update()
end

function object:draw()
  for k,child in pairs(self.children) do
    child:draw() -- ascending recursion
    child:__draw()
  end
  self:__draw()
end

return object
