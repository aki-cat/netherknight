
local gamestate = basic.prototype:new {
  __type = 'gamestate'
}

function gamestate:__init ()
  self.bodies = {}
  self.drawables = {}
end

function gamestate:getplayerbody ()
  return self.bodies.player
end

function gamestate:getplayersprite ()
  return self.drawables.player
end

function gamestate:add_body (name, body)
  assert(not self.bodies[name], "Cannot add second body of same name.")
  self.bodies[name] = body
end

function gamestate:del_body (name)
  assert(self.bodies[name], "Cannot remove body that doesn't exist.")
  self.bodies[name] = nil
end

function gamestate:add_drawable (name, drawable)
  assert(not self.drawables[name], "Cannot add second drawable of same name.")
  self.drawables[name] = drawable
end

function gamestate:del_drawable (name)
  assert(self.drawables[name], "Cannot remove drawable that doesn't exist.")
  self.drawables[name] = nil
end

function gamestate:synchronize (bodyname)
  if self.drawables[bodyname] then
    local body = self.bodies[bodyname]
    local drawable = self.drawables[bodyname]
    drawable.pos:set(body.pos:unpack())
  end
end

return gamestate
