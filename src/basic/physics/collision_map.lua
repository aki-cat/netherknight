
local vector = require 'basic.vector'

local collision_map = require 'basic.prototype' :new {
  16, 10,
  __type = 'CollisionMap'
}

function collision_map:__init()
  self:generate(self[1], self[2])
end

function collision_map:generate(width, height)
  self.map = require 'basic.matrix' :new { width, height, 0 }
end

function collision_map:get_nine_poins (x, y, w, h)
  -- we add 1 because most maps start from zero
  x = x + 1
  y = y + 1
  return
    vector:new{ math.floor(x),         math.floor(y)         },
    vector:new{ math.floor(x),         math.floor(y + h / 1) },
    vector:new{ math.floor(x),         math.floor(y + h / 2) },
    vector:new{ math.floor(x + w / 2), math.floor(y)         },
    vector:new{ math.floor(x + w / 1), math.floor(y)         },
    vector:new{ math.floor(x + w / 1), math.floor(y + h / 2) },
    vector:new{ math.floor(x + w / 1), math.floor(y + h / 1) },
    vector:new{ math.floor(x + w / 2), math.floor(y + h / 1) },
    vector:new{ math.floor(x + w / 2), math.floor(y + h / 2) }
end

function collision_map:is_area_occupied (x, y, w, h)
  local occupied = false
  local a, b, c, d, e, f, g, h, i = self:get_nine_poins(x, y, w, h)
  if self.map:get(a.i, a.j) and self.map:get(a.i, a.j) ~= 0 then occupied = true end
  if self.map:get(b.i, b.j) and self.map:get(b.i, b.j) ~= 0 then occupied = true end
  if self.map:get(c.i, c.j) and self.map:get(c.i, c.j) ~= 0 then occupied = true end
  if self.map:get(d.i, d.j) and self.map:get(d.i, d.j) ~= 0 then occupied = true end
  if self.map:get(e.i, e.j) and self.map:get(e.i, e.j) ~= 0 then occupied = true end
  if self.map:get(f.i, f.j) and self.map:get(f.i, f.j) ~= 0 then occupied = true end
  if self.map:get(g.i, g.j) and self.map:get(g.i, g.j) ~= 0 then occupied = true end
  if self.map:get(h.i, h.j) and self.map:get(h.i, h.j) ~= 0 then occupied = true end
  if self.map:get(i.i, i.j) and self.map:get(i.i, i.j) ~= 0 then occupied = true end
  return occupied
end

function collision_map:occupy_tile (x, y, value)
  if value == nil then return end
  self.map:set(y, x, value)
end

return collision_map
