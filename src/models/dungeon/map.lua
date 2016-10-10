
local map = require 'model' :new {}

local matrix = require 'basic.matrix'

function map:__init()
  self.rooms = matrix:new {}
  self.current = false
end

function map:set_size (width, height)
  self.rooms = matrix:new { width, height }
end

function map:set_current (id)
  self.current = id
end

function map:get_current ()
  return self.current
end

function map:get_room (i, j)
  return matrix:get(i, j)
end

function map:set_room (i, j, id)
  matrix:set(i, j, id)
end

return map:new {}
