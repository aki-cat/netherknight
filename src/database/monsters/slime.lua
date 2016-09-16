
local behaviour = false

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

return function(self)
  if not behaviour then
    behaviour = coroutine.create(action)
    print("new coroutine!")
  end
  assert(coroutine.resume(behaviour, self), 'Coroutine died!')

end
