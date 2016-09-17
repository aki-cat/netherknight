
local gamestate = basic.prototype:new {
  __type = 'gamestate'
}

function gamestate:__init ()
  self.bodies = { __length = 0 }
  self.drawables = { __length = 0 }
end

function gamestate:getbody (name)
  return self.bodies[name]
end

function gamestate:getsprite (name)
  return self.drawables[name]
end

function gamestate:findbody (somebody)
  for name, body in pairs(self.bodies) do
    if body == somebody then return name end
  end
  return false
end

function gamestate:add_body (name, body)
  assert(not self.bodies[name], "Cannot add second body of same name.")
  self.bodies[name] = body
  self.bodies.__length = self.bodies.__length + 1
end

function gamestate:del_body (name)
  assert(self.bodies[name], "Cannot remove body that doesn't exist.")
  self.bodies[name] = nil
  self.bodies.__length = self.bodies.__length - 1
end

function gamestate:add_drawable (name, drawable)
  assert(not self.drawables[name], "Cannot add second drawable of same name.")
  self.drawables[name] = drawable
  self.drawables.__length = self.drawables.__length + 1
end

function gamestate:del_drawable (name)
  assert(self.drawables[name], "Cannot remove drawable that doesn't exist.")
  self.drawables[name] = nil
  self.drawables.__length = self.drawables.__length - 1
end

function gamestate:synchronize (bodyname)
  if self.drawables[bodyname] then
    local body = self.bodies[bodyname]
    local drawable = self.drawables[bodyname]
    drawable.pos:set(body.pos:unpack())
  end
end

return gamestate
