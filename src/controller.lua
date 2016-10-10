
local controller = require 'basic.prototype' :new {
  'modelsection',
  __type = 'controller'
}

local BUFFER = 4096
local STOP = -1

function controller:__init ()
  -- create a new list of actions
  self.actions = {}
  
  -- get main model
  self.modelsection = self[1]

  self.timer = timer:new {}
  self.queue = require 'basic.queue' :new { BUFFER }
end

function controller:get_model (name)
  local path_to_model = 'models.' .. self.modelsection .. '.' .. name
  return require(path_to_model)
end

function controller:get_distant_model (section, name)
  local path_to_model = 'models.' .. section .. '.' .. name
  return require(path_to_model)
end

function controller:execute (s, ...)
  if self.actions[s] then self.actions[s](...) end
end

function controller:register_action (name, handle)
  assert(name and handle, "Cannot register action without both name (string) and handle (function)!")
  if self.actions[name] then print(self[2] .. " | WARNING: Overwriting already existing action: " .. name) end
  self.actions[name] = handle
end

function controller:update ()
  -- update timers
  self.timer:update()
end

return controller
