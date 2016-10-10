
return function (id)
  while true do
    local vector = require 'basic.vector'
    local angle = math.pi * 2 * math.random()
    local idle = math.random()
    local speed = globals.frameunit / 4
    local acc = speed * vector:new { math.cos(angle), -math.sin(angle) }

    if idle <= .333 then
      for i=1, math.floor(globals.framerate * 0.5) do
        coroutine.yield()
      end
    elseif idle <= .666 then
      for i=1, math.floor(globals.framerate * 1.0) do
        signal.broadcast('move', id, acc)
        coroutine.yield()
      end
    else
      for i=1, math.floor(globals.framerate * 1.0) do
        print("CHASING!")
        signal.broadcast('chase', id, speed)
        coroutine.yield()
      end
    end
  end
end
