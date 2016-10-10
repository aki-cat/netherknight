
local player = require 'element' :new {
  __type = 'player'
}

function player:__init ()
  self.lock = false
  self.timer = require 'basic.timer' :new {}
end

function player:is_locked ()
  return self.lock
end

function player:lock (time)
  self.lock = true
  self.timer:after(time, function ()
    self.lock = false
  end)
end

function player:unlock (time)
  self.lock = false
  self.timer:clear()
end

function player:update ()
  self.timer:update()
end

return player
