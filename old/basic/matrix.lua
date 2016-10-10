
local iterate = require 'basic.iterate'

local matrix = require 'basic.prototype' :new {
  3, 3, 0,
  __type = 'matrix'
}

local function fill_matrix (t, width, height, fill)
  for i = 1, height do
    t[i] = {}
    for j = 1, width do
      t[i][j] = fill or 0
    end
  end
end

function matrix:__init ()
  local width, height, fill = self[1], self[2], self[3]
  fill_matrix(self, width, height, fill)
end

function matrix:set (i, j, fill)
  assert(self[i], "Invalid row: " .. i)
  assert(self[i][j], "Invalid column: " .. j)
  self[i][j] = fill or 0
end

function matrix:get (i, j)
  local dummy = {}
  return (self[i] or dummy)[j]
end

function matrix:get_width ()
  return #self[1]
end

function matrix:get_height ()
  return #self
end

matrix.iterate = iterate.matrix

function matrix:iteraterows ()
  local t = { 0, m = self }
  return function(s, row)
    local m = s.m
    local i
    s[1] = s[1] + 1
    i = s[1]
    row = m[i]
    return row and i, row
  end,
  t,
  0
end

return matrix
