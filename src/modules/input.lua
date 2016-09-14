
local input = orangelua.prototype:new {
  keymap = {
    quit   = 'f8',
    maru   = 'z',
    batsu  = 'x',
    up     = 'up',
    right  = 'right',
    down   = 'down',
    left   = 'left',
  },
  __type = 'input'
}

function input:checkpress (k)
  for action,key in pairs(self.keymap) do
    if key == k then input:handlepress(action) end
  end
end

function input:checkrelease (k)
  for action,key in pairs(self.keymap) do
    if key == k then input:handlerelease(action) end
  end
end

function input:checkhold ()
  for action,key in pairs(self.keymap) do
    if love.keyboard.isDown(key) then self:handlehold(action) end
  end
end

function input:handlepress (action)
  print("pressed:", action)
  hump.signal.emit('presskey', action)
end

function input:handlerelease (action)
  print("released:", action)
  hump.signal.emit('releasekey', action)
end

function input:handlehold (action)
  print("held:", action)
  hump.signal.emit('holdkey', action)
end

function input:update ()
  self:checkhold()
end

function input:__index (k)
  return getmetatable(self)[k]
end

return input:new {}
