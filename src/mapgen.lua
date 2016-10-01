
local mapgen = basic.prototype:new {
  3, 3,
  __type = 'mapgen'
}

local dirs = {
  basic.vector:new {  0,  1 }, -- up
  basic.vector:new {  1,  0 }, -- right
  basic.vector:new {  0, -1 }, -- down
  basic.vector:new { -1,  0 }, -- left
}

function map:generate ()
  local pos = basic.vector:new { 1, 1 }
  local candidates = { pos }
  while #candidates > 0 do

    -- get random candidate
    local len = #candidates
    local k = love.math.random(1, len)
    local c = candidates[k]
    candidates[k] = candidates[len]
    candidates[len] = nil

    -- fill candidate
    table.insert(self.rooms, module.roomgen:new {})

    -- get new candidates
    for n = 1, 4 do
      if not basic.iterate.find(candidates, c) and not basic.iterate.find(self.rooms, c) then
        -- insert new candidates
      end
    end

  end
end

function map:connect (r1, r2)
  self.connections:set(r1, r2, true)
  self.connections:set(r2, r1, true)
end

function map:__init ()
  local columns, rows = self[1], self[2]
  self.rooms = {}
  self.connections = basic.matrix:new { columns * rows, columns * rows, 0 }

end

return mapgen
