
local input = class.object:new {
  keymap = {
    quit   = 'f8',
    maru   = 'z',
    batsu  = 'x',
    up     = 'up',
    right  = 'right',
    down   = 'down',
    left   = 'left',
  }
  __type = 'input'
}

function input:checkpress (key)
  input:handlepress(key)
end

function input:checkrelease (key)
  input:handlerelease(key)
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

return input:new{}
