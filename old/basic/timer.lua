
-- individual timer
local timer = require 'basic.prototype' :new {
  target = 1,
  loop = 1,
  handle_frame = function () end,
  handle_period = function () end,
  __type = 'timer'
}

function timer:__init ()
  self.update = coroutine.create(self.routine)
end

function timer:routine ()
  while self.loop > 0 or self.loop == -1 do
    for i = 1, self.target do
      self.handle_frame()
      coroutine.yield()
    end
    self.handle_period()
    self.loop = self.loop == -1 and -1 or self.loop -1
  end
end

-- timer manager
local timer_manager = require 'basic.prototype' :new {
  framerate = 60,
  __type = 'timer_manager'
}

function timer_manager:__init ()
  self.timers = {}
  self.framerate = math.floor(self.framerate)
end

function timer_manager:setfps (fps)
  self.framerate = math.floor(fps)
end

function timer_manager:clear ()
  for id,_ in pairs(self.timers) do
    self.timers[id] = nil
  end
end

function timer_manager:cancel (t)
  assert(t, "TimerManager method 'cancel' must receive timer handle as argument.")
  self.timers[t] = nil
end

function timer_manager:update ()
  for t in pairs(self.timers) do
    local unfinished, status = coroutine.resume(t.update, t)
    --if status then print(status) end
    if not unfinished then
      self.timers[t] = nil
    end
  end
end

function timer_manager:after (s, func)
  assert(s > 0, "Must give a positive time in seconds as first argument.")
  assert(type(func)=='function', "Must give a valid function as second argument.")
  local t = timer:new {
    target = s * self.framerate,
    handle_period = func,
  }
  self.timers[t] = t
  return t
end

function timer_manager:every (s, func, times)
  assert(s > 0, "Must give a positive time in seconds as first argument.")
  assert(type(func)=='function', "Must give a valid function as second argument.")
  local t = timer:new {
    target = s * self.framerate,
    handle_period = func,
    loop = times or -1,
  }
  self.timers[t] = t
  return t
end

function timer_manager:during (s, func_during, func_after)
  assert(s > 0, "Must give a positive time in seconds as first argument.")
  assert(type(func_during)=='function', "Must give a valid function as second argument.")
  local t = timer:new {
    target = s * self.framerate,
    handle_frame = func_during,
    handle_period = func_after or function () end,
  }
  self.timers[t] = t
  return t
end

return timer_manager:new {}
