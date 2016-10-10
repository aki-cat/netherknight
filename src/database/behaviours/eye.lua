
return function (id)
  while true do
    local vector = require 'basic.vector'
    local idle = math.random()
    local speed = globals.frameunit / 5

    if idle <= .333 then
      for i=1, globals.framerate * 1.0 do
        coroutine.yield()
      end
    else
      for i=1, globals.framerate * 2.0 do
        print("CHASING!")
        signal.broadcast('chase', id, speed)
        coroutine.yield()
      end
    end
  end
end
