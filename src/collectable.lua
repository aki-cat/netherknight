
local sprites = basic.pack 'database.sprites'
local sprite = require 'sprite'

local collectable = module.entity:new {
  [3] = 1/2,
  [4] = 1/4,
  item = 'drumstick',
  __type = 'collectable'
}

function collectable:__init ()
  self.maxhp = 1
end

function collectable:drop ()
  local name = self:get_type() .. tostring(self):sub(-7)
  basic.signal:emit('add_entity', name, self)
  basic.signal:emit('add_sprite', name, sprite:new { sprites[self.item] })
  basic.timer:after(
    4,
    function ()
      basic.signal:emit('blink', name, 'slow', 1)
      basic.timer:after(1, function () basic.signal:emit('blink', name, 'fast', 1) end)
      basic.timer:after(2, function () self.damage = 999 end)
    end
  )
end

function collectable:on_collision (somebody)
  if somebody:get_type() == 'player' then
    self.damage = 999
    basic.signal:emit('get_item', self.item)
  end
end

function collectable:on_death ()
  basic.signal:emit('entity_death', self)
end

function collectable:draw ()
  module.entity.draw(self) -- call entity draw
end


return collectable
