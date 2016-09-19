
local slime = {
  size = 1/5,
  maxhp  = 3,
  attack = 1,
}

local function action(self)
  while true do
    local angle = math.pi * 2 * math.random()
    local idle = math.random(0, 1)
    local count = 0
    local speed = globals.frameunit / 4
    local movement = speed * basic.vector:new{
      math.cos(angle),
      math.sin(angle)
    }

    if idle == 1 then
      for i=1, globals.framerate * 0.5 do
        coroutine.yield()
      end
    else
      for i=1, globals.framerate * 1.0 do
        self:move(movement)
        coroutine.yield()
      end
    end
  end
end

function slime:update()
  if not self.behaviour then
    self.behaviour = coroutine.create(action)
    print("new coroutine!")
  end
  local status, info = coroutine.resume(self.behaviour, self)
  if not status then print(info) end
  assert(status, "Coroutine error!")
end

return slime
