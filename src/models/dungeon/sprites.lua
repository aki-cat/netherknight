
local sprites = require 'model' :new {}

function sprites:death_animation (sprite, offset)
  local id = unique_id:generate()
  local death = require 'elements.sprite' :new { 'death' }
  local DEATH_TIME = 0.6

  -- setup death animaiton
  death:set_id(id)
  local deathpos = sprite:get_pos() + offset
  deathpos.z = 1
  death:set_pos(deathpos:unpack())
  self:add_element(death)

  -- setup animation duration
  self.timer:during(DEATH_TIME, function ()
    local deathpos = sprite:get_pos() + offset
    deathpos.z = 1
    death:set_pos(deathpos:unpack())
  end, function ()
    self:remove_element(id)
    self:remove_element(sprite:get_id())
  end)
end

function sprites:sort_by_y ()
  local pool = self:get_pool()
  table.sort(pool, function(a,b)
    local apos, bpos = a:get_pos(), b:get_pos()
    return apos.z == bpos.z and apos.y < bpos.y or apos.z < bpos.z
  end)
end

function sprites:update ()
  self.timer:update()
  local pool = self:get_pool()
  for index, sprite in ipairs(pool) do
    sprite:update()
  end
  self:sort_by_y()
end

function sprites:draw ()
  local pool = self:get_pool()
  for index, sprite in ipairs(pool) do
    sprite:draw()
  end
end

return sprites:new {}
