
local sprites = basic.pack 'database.sprites'

local collectable = require 'entity' :new {
  item = 'drumstick',
  __type = 'collectable'
}

function collectable:__init ()
end

function collectable:on_collision (somebody)
  if somebody:get_type() == 'player' then
    audio:playSFX('Get')
    table.insert(gamedata.inventory, self.item)
    self.damage = 99999
  end
end

function collectable:draw ()
  -- just so it doesn't use its super's method
end

return collectable
