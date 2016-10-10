
local input = require 'basic.prototype' :new {
  action_keymap = {
    quit        = 'f8',
    maru        = 'z',
    batsu       = 'x',
    inventory   = 'c',
    pause       = 'escape',
    marco       = 'm',
  },
  direction_keymap = {
    up          = 'up',
    right       = 'right',
    down        = 'down',
    left        = 'left',
  },
  __type = 'input'
}

local function handle_action_press (action)
  signal.broadcast('press_action', action)
end

local function handle_action_release (action)
  signal.broadcast('release_action', action)
end

local function handle_action_hold (actions)
  for action, is_held in pairs(actions) do
    if is_held then
      signal.broadcast('hold_action', action)
    end
  end
end

local function handle_direction_press (direction)
  signal.broadcast('press_direction', direction)
end

local function handle_direction_release (direction)
  signal.broadcast('release_direction', direction)
end

local function handle_direction_hold (directions)
  if directions.up and directions.down then
    directions.up, directions.down = false, false
  end
  if directions.left and directions.right then
    directions.left, directions.right = false, false
  end
  if directions.up and directions.left then
    directions.up, directions.left = false, false
    directions.up_left = true
  end
  if directions.up and directions.right then
    directions.up, directions.right = false, false
    directions.up_right = true
  end
  if directions.down and directions.left then
    directions.down, directions.left = false, false
    directions.down_left = true
  end
  if directions.down and directions.right then
    directions.down, directions.right = false, false
    directions.down_right = true
  end
  for direction, is_held in pairs(directions) do
    if is_held then
      signal.broadcast('hold_direction', direction)
      return
    end
  end
  signal.broadcast('hold_direction', 'none')
end

function input:checkpress (k)
  for action,key in pairs(self.action_keymap) do
    if key == k then handle_action_press(action) end
  end
  for direction,key in pairs(self.direction_keymap) do
    if key == k then handle_direction_press(direction) end
  end
end

function input:checkrelease (k)
  for action,key in pairs(self.action_keymap) do
    if key == k then handle_action_release(action) end
  end
  for direction,key in pairs(self.direction_keymap) do
    if key == k then handle_direction_release(direction) end
  end
end

function input:checkhold ()
  local held_actions, held_directions = {}, {}
  for action,key in pairs(self.action_keymap) do
    held_actions[action] = love.keyboard.isDown(key)
  end
  for direction,key in pairs(self.direction_keymap) do
    held_directions[direction] = love.keyboard.isDown(key)
  end
  handle_action_hold(held_actions)
  handle_direction_hold(held_directions)
end

function input:update ()
  self:checkhold()
end

return input:new {}
