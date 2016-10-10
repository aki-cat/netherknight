
local player = require 'element' :new {
  __type = 'player'
}

function player:__init ()
  self.locked = false
  self.timer = require 'basic.timer' :new {}
end

function player:is_locked ()
  return self.locked
end

function player:lock (time)
  self.locked = true
  self.timer:after(time, function ()
    self.locked = false
  end)
end

function player:unlock (time)
  self.locked = false
  self.timer:clear()
end

function player:update ()
  self.timer:update()
end

return player
