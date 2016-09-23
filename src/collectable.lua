
local sprites = basic.pack 'database.sprites'
local entity = require 'entity'

local collectable = entity:new {
  [3] = 1/2,
  [4] = 1/4,
  item = 'drumstick',
  __type = 'collectable'
}

function collectable:__init ()
  self.maxhp = 1
end

function collectable:on_collision (somebody)
  if somebody:get_type() == 'player' then
    self.damage = 999
  end
end

function collectable:on_death ()
  table.insert(gamedata.inventory, self.item)
  audio:playSFX('Get')
  hump.signal.emit('entity_death', self)
end

function collectable:draw ()
  entity.draw(self) -- call entity draw
end


return collectable
