
local element = require 'basic.prototype' :new {
  __type = 'element'
}
local unique_id = require 'basic.unique'

function element:__init ()
  self.id = 0
end

function element:get_id ()
  return self.id
end

function element:set_id (id)
  self.id = id
end

function element:update ()
  -- implement on child
end

function element:draw ()
  -- implement on child
end

return element
