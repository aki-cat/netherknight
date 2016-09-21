
local sprites = basic.pack 'database.sprites'

local collectable = require 'entity' :new {
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

return collectable
