
local input = basic.prototype:new {
  keymap = {
    quit   = 'f8',
    maru   = 'z',
    batsu  = 'x',
    up     = 'up',
    right  = 'right',
    down   = 'down',
    left   = 'left',
    marco  = 'm',
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
  local held = {
    quit = false, maru = false, batsu = false,
    up = false, right = false, down = false, left = false,
  }
  for action,key in pairs(self.keymap) do
    if love.keyboard.isDown(key) then held[action] = true end
  end
  self:handlehold(held)
end

function input:handlepress (action)
  --print("pressed:", action)
  hump.signal.emit('presskey', action)
end

function input:handlerelease (action)
  --print("released:", action)
  hump.signal.emit('releasekey', action)
end

local function handle_direction (dir)
  if dir.up and dir.down then
    dir.up, dir.down = false, false
  end
  if dir.left and dir.right then
    dir.left, dir.right = false, false
  end
  if dir.up and dir.left then
    dir.up, dir.left = false, false
    dir.up_left = true
  end
  if dir.up and dir.right then
    dir.up, dir.right = false, false
    dir.up_right = true
  end
  if dir.down and dir.left then
    dir.down, dir.left = false, false
    dir.down_left = true
  end
  if dir.down and dir.right then
    dir.down, dir.right = false, false
    dir.down_right = true
  end
end

function input:handlehold (actions)
  handle_direction(actions)
  for action,acting in pairs(actions) do
    if acting then
      --print("held:", action)
      hump.signal.emit('holdkey', action)
    end
  end
end

function input:update ()
  self:checkhold()
end

function input:__index (k)
  return getmetatable(self)[k]
end

return input:new {}
